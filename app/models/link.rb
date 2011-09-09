class Link

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Callbacks
  extend ActiveModel::Naming

  define_model_callbacks :save

  attr_accessor :url, :key

  validates :url, :presence => true, :url => true
  before_save :generate_key

  def to_param
    self.key
  end

  def self.popular
    []
  end

  def self.find(key)
    return nil unless key
    begin
      url = Couch.client.get(key)
      self.new(:key => key, :url => url)
    rescue Memcached::NotFound => e
      nil
    end
  end

  def initialize(attributes = {})
    @errors = ActiveModel::Errors.new(self)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    return false unless key
    return false unless valid?
    self.class.find(key).url == self.url
  end

  def save
    return false unless valid?
    run_callbacks :save do
      Couch.client.set(self.key, self.url)
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