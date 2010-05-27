class SendmailNotifier
  def initialize(from, to, subject)
    @from = from
    @to   = to
    @subject = subject
  end

  def notify(checker)
    email = <<-EOF
Date: #{send_date}
From: #{@from}
To: #{@to}
Reply-To: #{@from}
Subject: #{@subject}
Mime-Version: 1.0
#{message(threshold, exceed_by)}
EOF
    `echo "#{email}" | /usr/sbin/sendmail -t`
  end
protected

  def send_date
    Time.now.strftime("%a, %b %d %H:%M:%S %Z")
  end

  def message(checker)
    hostname = `hostname`
    exceeded_by = checker.new_occurences - checker.threshold
    <<-MSG
[#{hostname}]: #{checker.new_occurences} new occurences. threshold is #{exceeded_by}.
    MSG
  end
end