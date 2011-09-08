class Link

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Callbacks
  extend ActiveModel::Naming

  define_model_callbacks :save

  attr_accessor :url, :key

  validates :url, :presence => true
  before_save :generate_key

  def self.popular
    []
  end

  def self.find(key)
    begin
      Couch.client.get(self.key)
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
    false
  end

  def save
    Couch.client.set(self.key, {
      :url => self.url,
      :key => self.key
    })
  end

  def generate_key
    while self.key.nil?
      random = SecureRandom.hex(2)
      self.key = random if self.class.find(random).nil?
    end
  end

end