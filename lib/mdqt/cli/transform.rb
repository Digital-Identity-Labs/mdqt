module MDQT

  class CLI

    require 'mdqt/cli/base'

    class Transform < Base

      IdentifierUtils = MDQT::Client::IdentifierUtils

      def run

        halt!("No entityIDs have been specified!") if args.empty?

        args.each do |arg|
          puts transform(arg)
        end

      end

      def transform(arg)
        arg = arg.strip
        return arg if IdentifierUtils.valid_transformed?(arg)
        return IdentifierUtils.correct_lazy_transformed(arg) if IdentifierUtils.lazy_transformed?(arg)
        return IdentifierUtils.correct_fish_transformed(arg) if IdentifierUtils.fish_transformed?(arg)
        IdentifierUtils.transform_uri(arg)
      end

    end

  end
end

