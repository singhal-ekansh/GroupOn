VERIFY_EXPIRE_TIME = Rails.env.production? ? 30.minutes : 5.minutes 
RESET_EXPIRE_TIME = Rails.env.production? ? 30.minutes : 5.minutes
DEFAULT_MAIL = 'from@example.com'
ALLOWED_IMAGE_TYPES = %w[image/jpg image/png]
ALLOWED_IMAGE_SIZE = 5000000 #5mb
ORDER_VERIFY_JOB__WAIT_TIME = 10.minutes