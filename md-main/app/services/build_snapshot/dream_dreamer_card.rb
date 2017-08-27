module BuildSnapshot
  class DreamDreamerCard
    def self.call(dream)
      dreamer = dream.dreamer
      html = ApplicationController.new.render_to_string(
        template: 'build_snapshot/dream_dreamer',
        layout: 'build_snapshot',
        locals: { dream: dream, dreamer: dreamer, current_dreamer: dreamer }
      )

      kit = IMGKit.new(
        html,
        quality: 100, width: 430, height: 320
      )

      file = Tempfile.new(["template_#{dream.id}_#{dreamer.id}", '.jpg'], 'tmp',
                          encoding: 'ascii-8bit')
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
