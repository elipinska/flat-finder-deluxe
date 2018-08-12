require "mail"

class Mailer
  def initialize
    options = { :address              => "smtp.gmail.com",
                :port                 => 587,
                :user_name            => ENV["FLAT_FINDER_SENDER"],
                :password             => ENV["FLAT_FINDER_PASSW"],
                :authentication       => "plain",
                :enable_starttls_auto => true  }

    Mail.defaults do
      delivery_method :smtp, options
    end
  end

  def send(results)
    p "Sending email with results..."
    text = results.map { |result| "#{result}\n\n" }

# E-mail search results to yourself
    Mail.deliver do
           to ENV["FLAT_FINDER_SENDER"]
         from ENV["FLAT_FINDER_SENDER"]
      subject "Your latest #{results.length} 🏡"
         body text
    end

# E-mail search results to another person
    Mail.deliver do
           to ENV["FLAT_FINDER_RECEIVER"]
         from ENV["FLAT_FINDER_SENDER"]
      subject "Your latest #{results.length} 🏡"
         body text
    end
  end
end
