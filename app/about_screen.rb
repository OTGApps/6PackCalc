class AboutScreen < Formotion::FormController

  def init
    @form ||= Formotion::Form.new({
      sections: [{
        title: 'Share With Your friends:',
        rows: [{
          title: 'Share the app',
          subtitle: 'Text, Email, Tweet, or Facebook!',
          type: :share,
          image: 'share',
          value: {
            items: "I'm using the '#{App.name}' app to calculate how much beer costs. Check it out! http://www.mohawkapps.com/app/6pack-calc/",
            excluded: excluded_services
          }
        }, {
          title: "Rate on iTunes",
          type: :rate_itunes,
          image: 'itunes'
        }]
      }, {
        title: "#{App.name} is open source:",
        rows: [{
          title: 'View on GitHub',
          type: :github_link,
          image: 'github',
          warn: true,
          value: 'https://github.com/MohawkApps/6PackCalc'
        }, {
          title: 'Found a bug?',
          subtitle: 'Log it here.',
          type: :issue_link,
          image: 'issue',
          warn: true,
          value: 'https://github.com/MohawkApps/6PackCalc/issues/'
        }]
      }, {
        title: "About #{App.name}:",
        rows: [{
          title: 'Version',
          type: :static,
          placeholder: App.info_plist['CFBundleShortVersionString'],
          selection_style: :none
        }, {
          title: 'Copyright',
          type: :static,
          font: { name: 'HelveticaNeue', size: 14 },
          placeholder: '© 2014, Mohawk Apps, LLC',
          selection_style: :none
        }, {
          title: 'Visit MohawkApps.com',
          type: :web_link,
          warn: true,
          value: 'http://www.mohawkapps.com'
        }, {
          # This is technically a lie since I started writing this at 30,000 feet
          # And then finished it at #Inspect 2014 in San Francisco.
          # But it's the spirit of the thing. NC is my home.
          title: 'Made with ♥ in North Carolina',
          type: :static,
          enabled: false,
          selection_style: :none,
          text_alignment: NSTextAlignmentCenter
        }, {
          type: :static_image,
          value: 'nc',
          enabled: false,
          selection_style: :none
        }]
      }]
    })
    Flurry.logEvent("VIEWED_ABOUT") unless Device.simulator?
    super.initWithForm(@form)
  end

  def viewDidLoad
    super
    self.title = 'About'
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemStop, target:self, action:'close')
  end

  def close
    dismissModalViewControllerAnimated(true)
  end

  def excluded_services
    [
      UIActivityTypeAddToReadingList,
      UIActivityTypeAirDrop,
      UIActivityTypeCopyToPasteboard,
      UIActivityTypePrint
    ]
  end
end
