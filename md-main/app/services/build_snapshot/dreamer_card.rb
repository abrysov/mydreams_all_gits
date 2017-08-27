module BuildSnapshot
  class DreamerCard
    def self.call(dreamer)
      html = ApplicationController.new.render_to_string(
        template: 'build_snapshot/dreamer',
        layout: 'build_snapshot',
        locals: { dreamer: dreamer }
      )

      kit = IMGKit.new(
        html,
        quality: 100, width: 210, height: 320
      )

      file = Tempfile.new(["template_#{dreamer.id}", '.jpg'], 'tmp', encoding: 'ascii-8bit')
      file.write(kit.to_jpg)
      file.flush

      if file
        Result::Success.new file
      else
        file.flush
        Result::Error.new
      end
    end
  end
end
