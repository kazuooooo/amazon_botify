class WebDriver

  AMAZON_URL      = 'https://www.amazon.com/'
  PRODUCT_URL     = "https://#{ENV['AMAZON_BOT_DOMAIN']}/dp/"
  SCREENSHOT_NAME = 'order.png'
  NORMAL_ORDER_RADIO_KLASS = 'a-icon-radio-inactive'

  attr_accessor :email, :password, :driver, :headless

  def initialize
    @email    = ENV['AMAZON_BOT_EMAIL']
    @password = ENV['AMAZON_BOT_PASSWORD']
    @driver = Selenium::WebDriver.for(:chrome)
  end

  def order(amazon_product_id, exec_order)

    p 'go_to(AMAZON_URL)'
    go_to(AMAZON_URL)

    p 'click(\'nav-link-accountList\')'
    click('nav-link-accountList')
    login

    p 'go_to(PRODUCT_URL + amazon_product_id.to_s)'
    go_to(PRODUCT_URL + amazon_product_id.to_s)

    begin
      click(NORMAL_ORDER_RADIO_KLASS, :class)
      driver.find_element(:class, NORMAL_ORDER_RADIO_KLASS)
    rescue Selenium::WebDriver::Error::NoSuchElementError
      # It's ok if radio class element not find
    end

    p "click('add-to-cart-button')"
    click('add-to-cart-button')

    p "click('hlb-ptc-btn-native')"
    click('hlb-ptc-btn-native')

    login
    driver.find_element(:name, 'placeYourOrder1').click if exec_order
    screenshot
    quit
  end

  private
  def go_to(url)
    driver.navigate.to url
  end

  def find(element, type = :id)
    driver.find_element(type, element)
  end

  def click(element, type = :id)
    find(element, type).click
  end

  def input(element, value)
    find(element).send_keys(value)
  end

  def login
    input('ap_email', email)
    input('ap_password', password)
    click('signInSubmit')
  end

  def screenshot
    driver.save_screenshot(SCREENSHOT_NAME)
  end

  def quit
    driver.quit
  end
end