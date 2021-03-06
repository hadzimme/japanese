# -*- coding: utf-8 -*-

require 'yaml'

module Japanese
  class PosString < String
    def initialize(string)
      super
      self.freeze
    end

    def dup
      self.to_s
    end
  end

  class OpenWord < PosString
  end

  class ClosedWord < PosString
    def +(latter)
      if latter.is_a(self.class)
      else
        super
      end
    end
  end

  class ClosedWordPhrase < ClosedWord
  end

  class Adj < OpenWord
    class ClosedAdj < ClosedWord
    end
  end

  class Adnominal < OpenWord
  end

  class Adverb < OpenWord
  end

  class Auxil < ClosedWord
    def initialize(string, cform)
      @connectable_form = cform
      super(string)
    end
    attr_reader :connectable_form
  end

  class Conjunction < ClosedWord
  end

  class Interjection < OpenWord
  end

  class Noun < OpenWord
    class Adjv < OpenWord
    end

    class Adverbal < OpenWord
    end

    class Demonst < OpenWord
    end

    class Nai < OpenWord
    end

    class Name < OpenWord
    end

    class Number < OpenWord
    end

    class Org < OpenWord
    end

    class Others < ClosedWord
    end

    class Place < OpenWord
    end

    class Proper < OpenWord
    end

    class Verbal < OpenWord
    end
  end

  class Others < ClosedWord
  end

  class PostpCol < ClosedWord
  end

  class Postp < ClosedWord
  end

  class Prefix < ClosedWord
    def initialize(string, pos)
      @pos = pos
      super(string)
    end
  end

  class Suffix < ClosedWord
    def initialize(string, pos)
      @pos = pos
      super(string)
    end
  end

  class Symbol < ClosedWord
  end

  class Verb < OpenWord
    class ClosedVerb < ClosedWord
    end
    file_dir = File.dirname(File.expand_path(__FILE__))
    conf_path = file_dir + '/japanese/verb.yml'
    @@ending = YAML.load_file(conf_path)
    def initialize(string, ctype)
      @ctype = ctype
      @ending = @@ending[ctype]
      super
    end

    def conjugate(form)
      raise "form '#{form}' is not defined" unless @ending.key?(form)
      self.sub(/#{@ending['基本形']}$/, '') + @ending[form]
    end

    def +(latter)
      if latter.respond_to?(:connectable_form)
        connect(latter)
      else
        super
      end
    end

    private
    def connect(latter)
      conjugate(latter.connectable_form) + accept_former(latter)
    end

    def accept_former(latter)
      rendaku_able?(latter) ? rendaku(latter) : latter
    end

    def rendaku_able?(latter)
      @ctype[/^五段・[ガナバマ]行$/] && latter.connectable_form == '連用タ接続'
    end

    def rendaku(latter)
      rendaku_map = {'た' => 'だ', 'ち' => 'じ', 'て' => 'で', 'と' => 'ど'}
      latter.sub(/^./, rendaku_map)
    end
  end
end
