module FlashHelper
  def flash_message_type_to_class(type)
    { alert: :danger, error: :danger, failure: :danger, notice: :success }[type.to_sym] || type
  end

  def flash_messages(flash: self.flash, &block)
    messages = flash_to_messages flash: flash
    content  = render 'shared/flash_messages', messages: messages

    block ? capture(content, &block) : content if messages.any?
  end

  def flash_to_messages(flash: self.flash, reject: [:form])
    messages = []

    flash.each do |type, value|
      next if reject.include? type.to_sym

      Array.wrap(value).each do |message|
        messages << [type, message]
      end
    end

    messages
  end
end