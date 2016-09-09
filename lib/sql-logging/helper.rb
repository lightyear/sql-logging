module SqlLogging
  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::NumberHelper
  end
end
