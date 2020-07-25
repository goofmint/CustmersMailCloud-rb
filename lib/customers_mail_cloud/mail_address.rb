module CustomersMailCloud
  class MailAddress
    def initialize email, name
      @email = email
      @name = name
    end
    attr_accessor :email, :name

    def to_h
      return {address: @email, name: @name}
    end
  end
end