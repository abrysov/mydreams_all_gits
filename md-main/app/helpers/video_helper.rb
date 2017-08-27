module VideoHelper
  def video_id(certificate_name)
    {
      en: {
        bronze: 'm2NRJ5Q_x4w',
        silver: 'LX42IGimScw',
        gold: '9DiJA207tlE',
        platinum: 'B8j55pXCZPc',
        vip: '4lxq18cr2DY',
        presidential: '9NO4wL0NFIE',
        imperial: 'HXK2Zrrn_pU'
      },
      ru: {
        bronze: 'k7ztrmBm5Pw',
        silver: '3PII7MZH3ww',
        gold: 'YvxPs28B05Q',
        platinum: 'mPdnqJyN6js',
        vip: '1Jokt3VIYUY',
        presidential: 'tToQKUhhTOQ',
        imperial: 'm4HUqt_o9A8'
      }
    }[I18n.locale][certificate_name.to_sym]
  end

  def redirect_with_video_cpath(path, certificate)
    show_video_params = { new_certificate: Base64.strict_encode64(certificate.id.to_s) }.to_query

    "#{path}?#{show_video_params}"
  end

  def certificate_type_for(encoded_certificate_id)
    return unless encoded_certificate_id

    id = Base64.strict_decode64(encoded_certificate_id)
    certificate = Certificate.find id
    certificate.certificate_type.name
  end
end
