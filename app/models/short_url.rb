class ShortUrl < ApplicationRecord

    has_many :visitors
    validates :original_url, presence: true, on: :create
    validates_format_of :original_url,
    :with => /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,63}(:[0-9]{1,5})?(\/.*)?\z/ix
    before_create :gen_tiny_url
    before_create :sanitize
    UNIQUE_TOKEN_LENGTH = 8

    def gen_tiny_url
        url = ShortUrl.check_url_uniqueness
        self.short_url = url
    end

    def self.check_url_uniqueness
        url = ([*('a'..'z'),*('0'..'9')]).sample(UNIQUE_TOKEN_LENGTH).join
        old_url = where(short_url: url).last
        if old_url.present?
            return check_url_uniqueness
        else
           return url
        end
    end

    def check_for_duplicate_url
        ShortUrl.find_by_sanitize_url(self.sanitize_url)
    end

    def new_url?
        check_for_duplicate_url.nil?
    end

    def sanitize
        self.original_url.strip!
        self.sanitize_url = self.original_url.downcase.gsub(/(https?:\/\/)|(www\.)/,"")
        self.sanitize_url = "http://#{self.sanitize_url}"
        self.original_url.strip!
    end

end
