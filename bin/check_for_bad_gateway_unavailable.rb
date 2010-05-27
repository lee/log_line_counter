checker = ResponseCodeChecker.new(:response_codes => [502,503])
checker.perform_check