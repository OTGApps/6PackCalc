class CalculatorScreen < Formotion::FormController
  include BubbleWrap::KVO
  include ProMotion::ScreenModule

  attr_accessor :state

  def done(resetting = false)
    ap @form.render unless @form.nil?

    @state = @form.render
    # We need to get rid of this value if we're moving to another category.
    @state[:size] = nil if resetting

    # Refresh the data in the form
    build_form
    self.form = @form
    self.form.controller = self
    self.title = title # Setting the self.form item also clears the title :/
  end

  def init
    @state = {
      price: 0.0,
      container: :bottle
    }
    build_form
    super.initWithForm(@form)
  end

  def build_form
    unobserve_all

    @form = Formotion::Form.new(form_data)

    # Observe All Checkbox rows
    # TODO - there's GOT to be an easier way to do this. :/
    self.form.sections.each_with_index do |s, si|
      s.rows.each_with_index do |r, ri|
        if r.type == :check
          observe(self.form.sections[si].rows[ri], "value") do |old_value, new_value|
            if new_value == true
              EM.add_timer 0.1 do
                done(true)
              end
            end
          end
        end
      end
    end
  end

  def form_data
    {
      sections: [{
        title: 'Your Beer:',
        rows: [{
          title: 'Price:',
          type: :currency,
          key: :price,
          value: @state[:price] || nil,
          input_accessory: :done,
          done_action: -> { done }
        }]
      }, {
        title: "Container:",
        key: :container,
        select_one: true,
        rows: [{
          title: "Bottle",
          value: (@state[:container] == :bottle),
          key: :bottle,
          type: :check,
        }, {
          title: "Glass",
          value: (@state[:container] == :glass),
          key: :glass,
          type: :check,
        }, {
          title: "Keg",
          value: (@state[:container] == :keg),
          key: :keg,
          type: :check,
        }]
      }, {
        title: "#{@state[:container].to_s.titleize} Size:",
        rows: [{
          key: :size,
          type: :picker,
          items: picker_options,
          value: @state[:size] || default_option,
          input_accessory: :done,
          done_action: -> { done }
        }]
      },{
        title: 'A 6-Pack at this price would cost:',
        rows: [{
          type: :static,
          value: "$%.2f" % calculate
        },{
          type: :static,
          value: "(or $%.2f per bottle)" % calculate_one
        }]
      }]
    }
  end

  def calculate
    my_oz = BigDecimal.new(@state[:size] || default_option)
    six_pack_oz = BigDecimal.new(72.0)
    price = BigDecimal.new(@state[:price])

    (six_pack_oz / my_oz * price).to_f.round(2)
  end

  def calculate_one
    (calculate / 6).round(2)
  end

  def picker_options
    @form.nil? ? bottle : self.send(@form.render[:container].to_s)
  end

  def default_option
    picker_options[0][1]
  end

  def bottle
    [
      ['7 oz', '7.0'],
      ['11.2 oz', '11.2'],
      ['33 cl', '10.8204873'],
      ['12 oz', '12.0'],
      ['0.5 l (16.9 oz)', '16.9070114'],
      ['22 oz (bomber/rocket)', '22.0'],
      ['750 ml', '25.360517'],
      ['32 oz (bomber)', '32.0'],
      ['40 oz', '40.0'],
      ['64 oz growler', '64.0'],
      ['1 gal growler', '128.0']
    ]
  end

  def glass
    [
      ['Cheater pint (actual: 13 oz)', '13.0'],
      ['16 oz (actual: 15 oz)', '15.0'],
      ['16 oz fill line', '16.0'],
      ['20 oz (actual: 19 oz)', '19.0'],
      ['20 oz fill line', '20.0'],
      ['0.4 l fill line', '13.5256091'],
      ['0.5 l fill line', '16.9070114']
    ]
  end

  def keg
    [
      ['5 l mini-keg', '169.070114'],
      ['Soda (3 gal)', '384.0'],
      ['Cornelius (5 gal)', '640.0'],
      ['1/6 barrel (5.16 gal)', '660.48'],
      ['Pony (1/4 barrel / 7.75 gal)', '992.0'],
      ['Full (1/2 barrel / 15.5 gal)', '1984.0'],
    ]
  end

  def viewDidLoad
    super
    self.title = title

    set_nav_bar_button :right, {
      title: 'About',
      image: UIImage.imageNamed('info'),
      tint_color: UIColor.whiteColor,
      action: :show_about
    }
  end

  def show_about
    about_screen = AboutScreen.alloc.init
    nav_controller = UINavigationController.alloc.initWithRootViewController(about_screen)
    open_modal nav_controller
  end

  def title
    'Six Pack Calculator'
  end
end
