class Link

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Callbacks
  extend ActiveModel::Naming

  # Couch.client.save_design_doc('link', 'by_view_count' => {
  #   'map' => 'function(doc){ if(doc.type == "link"){ emit(doc.views, doc); }}'
  # })

  define_model_callbacks :save

  attr_accessor :url, :key, :views

  validates :url, :presence => true, :url => true
  before_save :generate_key

  def to_param
    self.key
  end

  def self.popular
    results = Couch.client.design_docs['link'].by_view_count.entries.sort { |a,b| b['key'] <=> a['key'] }
    results.map { |r| self.new(:key => r['value']['_id'], :url => r['value']['url'], :views => r['key']) } 
  end

  def self.find(key)
    return nil unless key
    begin
      doc = Couch.client.get(key)
      self.new(:key => key, :url => doc['url'], :views => doc['views'])
    rescue Memcached::NotFound => e
      nil
    end
  end

  def initialize(attributes = {})
    @errors = ActiveModel::Errors.new(self)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    self.views ||= 0
  end

  def persisted?
    return false unless key
    return false unless valid?
    self.class.find(key).url == self.url
  end

  def save
    return false unless valid?
    run_callbacks :save do
      Couch.client.set(self.key, {
        :type => self.class.to_s.downcase,
        :url => self.url,
        :key => self.key,
        :views => self.views
      })
      # TODO should set return nil if sucessful? don't think so
    end
    true
  end

  def generate_key
    while self.key.nil?
      random = SecureRandom.hex(2)
      self.key = random if self.class.find(random).nil?
    end
  end

end