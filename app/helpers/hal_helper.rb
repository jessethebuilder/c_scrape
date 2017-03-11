module HalHelper
  def hal
    Hal.first || Hal.create!
  end
end
