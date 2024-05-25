class ShortenedUrl < ApplicationRecord
  UNIQUE_ID_LENGTH = 6
  validates :original_url, presence: true, on: :create #run validations only on create
  validates :original_url, format: { with: URI::regexp(%w[http https]) }
  before_create :generate_short_url
  before_create :sanitize

  # Generates a unique short URL for the given web URL before saving it to the database
  def generate_short_url
    url = ([*("a".."z").to_a, *("0".."9").to_a]).sample(UNIQUE_ID_LENGTH).join
    puts url
    old_url = ShortenedUrl.where(short_url: url).last
    if old_url.present?
      self.generate_short_url
    else
      self.short_url = url
    end
  end

  def find_duplicate
    ShortenedUrl.find_by_sanitize_url(self.sanitize_url)
  end

  def new_url?
    find_duplicate.nil?
  end

  def sanitize
    self.original_url.strip!
    self.sanitize_url = self.original_url.downcase.gsub(/(https?:\/\/|www\.)/, "")
    self.sanitize_url = "http://#{self.sanitize_url}"
  end
end
