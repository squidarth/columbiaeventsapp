Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '263515600329607', '2649d032a1ca0e33122e3614184ad18c'
end