class WebDriver
  include Singleton

  AMAZON_URL      = 'https://www.amazon.com/'
  PRODUCT_URL     = "https://#{ENV['AMAZON_BOT_DOMAIN']}/dp/"
  DRIVER          = :remote
  SCREENSHOT_NAME = 'order.png'

  attr_accessor :email, :password, :driver

  def initialize
    @email    = ENV['AMAZON_BOT_EMAIL']
    @password = ENV['AMAZON_BOT_PASSWORD']
    @driver   = Selenium::WebDriver.for(:remote, url: "http://localhost:8910")
  end

  def order(amazon_product_id, exec_order)
    begin
      go_to(AMAZON_URL)

      click('nav-link-accountList')
      login

      go_to(PRODUCT_URL + amazon_product_id.to_s)
      click('add-to-cart-button')
      click('hlb-ptc-btn-native')

      login

      click('placeYourOrder1') if exec_order
    ensure
      quit
    end
  end

  private
  def go_to(url)
    driver.navigate.to url
  end

  def find(element_id)
    driver.find_element(:id, element_id)
  end

  def click(element_id)
    find(element_id).click
  end

  def input(element_id, value)
    find(element_id).send_keys(value)
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