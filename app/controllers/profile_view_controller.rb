class ProfileViewController < UIViewController

  extend IB

  outlet :profile_image_view
  outlet :email_label
  outlet :token_label

  def viewDidLoad
    super
    # Do any additional setup after loading the view.
    defaults = NSUserDefaults.standardUserDefaults
    user     = defaults['user']
    email    = user['email']
    token    = user['token']
    if user and email
      image_data = NSData.dataWithContentsOfURL(NSURL.URLWithString(gravatar(email)))
      profile_image_view.image = UIImage.imageWithData(image_data)
    end
    email_label.text = "#{email}"
    token_label.text = "#{token}"
  end

  def viewDidUnload
    super
    # Release any retained subviews of the main view.
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation == UIInterfaceOrientationPortrait
  end

  def gravatar(email)
    gravatar_id = RmDigest::MD5.hexdigest email.to_s.downcase
    gravatar_for_id(gravatar_id)
  end

  def gravatar_for_id(gid, size = 30)
    "http://www.gravatar.com/avatar/#{gid}?s=#{size}"
  end

end
