VERIFY_EXPIRE_TIME = Rails.env.production? ? 30.minutes : 5.minutes 
RESET_EXPIRE_TIME = Rails.env.production? ? 30.minutes : 5.minutes
DEFAULT_MAIL = 'from@example.com'
DEAL_PER_PAGE = 3
ORDER_PER_PAGE = 6