module HalHelper
  def hal
    Hal.first || Hal.create!(on: true)
  end
end
