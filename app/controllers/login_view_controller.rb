class LoginViewController < UIViewController

  extend IB

  attr_accessor :delegate

  outlet :input_field
  outlet :sign_in_btn, UIButton

  def viewDidLoad
    super
    # Do any additional setup after loading the view.
    self.view.when_tapped do
      if self.input_field.isFirstResponder
        self.input_field.resignFirstResponder
      end
    end
  end

  def viewDidUnload
    super
    # Release any retained subviews of the main view.
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation == UIInterfaceOrientationPortrait
  end

  def sign_in(sender)
    # CircleCi.configure { |c| c.token = input_field.text }
    # print  CircleCi::User.me
    circle = Circle.shared_instance
    circle.token = input_field.text
    circle.me do |me|
      return unless me.is_a?(Me)
      if me.token
        defaults = NSUserDefaults.standardUserDefaults
        defaults['user'] ||= {}
        defaults['user'] = defaults['user'].merge({'token' => me.token, 'email' => me.selected_email, 'login' => me.login})
        defaults.synchronize
        self.delegate.dismissViewControllerAnimated:true, completion: nil
      end
    end
  end

  def textFieldShouldReturn(text_field)
    if text_field.isFirstResponder
      text_field.resignFirstResponder
    end
  end

end
