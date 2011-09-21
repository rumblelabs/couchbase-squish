class Link

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Callbacks
  extend ActiveModel::Naming

  attr_accessor :url, :key, :views, :session_id, :created_at
  @@keys = [:url, :key, :views, :session_id, :created_at]

  define_model_callbacks :save
  validates :url, :presence => true, :url => {:allow_nil => true, :message => "This is not a valid URL"}
  before_save :generate_key

  def generate_key
    while self.key.nil?
      random = SecureRandom.hex(2)
      self.key = random if self.class.find(random).nil?
    end
  end

  # ActiveModel

  def initialize(attributes = {})
    @errors = ActiveModel::Errors.new(self)
    attributes.each do |name, value|
      next unless @@keys.include?(name.to_sym)
      send("#{name}=", value)
    end
    self.views ||= 0
    self.created_at ||= Time.zone.now
  end

  def to_param
    self.key
  end

  def persisted?
    return false unless (key && valid?)
    # TODO need a better way to track if an object is *dirty* or not...
    self.class.find(key).url == self.url
  end

  def save
    return false unless valid?
    run_callbacks :save do
      # TODO should client.set return nil if sucessful? don't think so
      Couch.client.set(self.key, {
        :type => self.class.to_s.downcase,
        :url => self.url,
        :key => self.key,
        :views => self.views,
        :session_id => self.session_id,
        :created_at => self.created_at
      })
    end
    true
  end

  def self.find(key)
    return nil unless key
    begin
      doc = Couch.client.get(key)
      self.new(doc)
    rescue Memcached::NotFound => e
      nil
    end
  end

  # Couchbase Views

  def self.design
    @@design ||= Couch.client.design_docs['link']
  end

  @@design_doc = {
    'by_view_count' => {
      'map' => 'function(doc){ if(doc.type == "link"){ emit(doc.views, doc); }}',
    },
    'by_session_id' => {
      'map' => 'function(doc){ if(doc.type == "link" && doc.session_id != null){ emit(doc.session_id, doc); }}',
    },
    'by_created_at' => {
      'map' => 'function(doc){ if(doc.type == "link" && doc.created_at != null){ emit(doc.created_at, doc); }}',
    }
  }

  if Couch.client.design_docs.include?("link")
    Couch.client.delete_design_doc('link')
    Couch.client.save_design_doc('link', @@design_doc)
  else
    Couch.client.save_design_doc('link', @@design_doc)
  end

  def self.popular
    results = design.by_view_count(:descending => true).entries
    results.map { |result| new(result['value']) }
  end

  def self.by_session_id(session_id)
    results = design.by_session_id(:key => session_id).entries
    results.map { |result| new(result['value']) }
  end

  def self.recent
    results = design.by_created_at(:descending => true).entries
    results.map { |result| new(result['value']) }
  end

end