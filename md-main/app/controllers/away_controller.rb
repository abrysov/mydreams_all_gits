class AwayController < ApplicationController
  def away
    banner = find_banner
    if banner
      inc_banner_cross_count(banner)
      redirect_to banner.link
    else
      raven_notify "Cant find banner, invalid link_hash=#{link_hash}"
      redirect_to root_path
    end
  end

  private

  def find_banner
    Banner.relevant.find_by(link_hash: link_hash)
  end

  def link_hash
    params[:link_hash]
  end

  def inc_banner_cross_count(banner)
    Banner.where(id: banner.id).update_all('cross_count = cross_count + 1')
  end
end
