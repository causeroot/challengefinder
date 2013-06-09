module ApplicationHelper

	def full_url(source)
		URI.join(root_url, url_for(challenge))
	end
end
