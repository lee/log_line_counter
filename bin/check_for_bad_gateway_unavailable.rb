checker = ResponseCodeChecker.new(:response_codes => [502,503],
                                  :threshold      => 3)
checker.perform_check