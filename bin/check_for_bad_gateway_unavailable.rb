checker = ResponseCodeChecker.new(:response_codes => [502,503],
                                  :threshold      => 3,
                                  :to => 'lee@weplay.com',
                                  :from => 'noreply@weplayalerts.com',
                                  :subject => "ALERT: 502 503 count exceeds threshold")
checker.perform_check