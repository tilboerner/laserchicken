class Page
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :id

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def new_record?() true end
  def persisted?() true end
  def destroyed?() true end

  def self.find(id)
    Page.new id: id
  end

  def previous
    Page.new(id: [1, self.to_i - 1].max)
  end

  def next
    Page.new(id: (self.to_i + 1))
  end

  def to_i
    self.id.to_i
  end


private
  attr_writer :id

end
