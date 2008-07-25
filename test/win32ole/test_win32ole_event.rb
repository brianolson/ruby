begin
  require 'win32ole'
rescue LoadError
end
require 'test/unit'

if defined?(WIN32OLE_EVENT)
  class TestWIN32OLE_EVENT < Test::Unit::TestCase
    def create_temp_html
      fso = WIN32OLE.new('Scripting.FileSystemObject')
      dummy_file = fso.GetTempName + ".html"
      cfolder = fso.getFolder(".")
      f = cfolder.CreateTextFile(dummy_file)
      f.writeLine("<html><body>This is test HTML file for Win32OLE.</body></html>")
      f.close
      dummy_path = cfolder.path + "\\" + dummy_file
      dummy_path
    end

    def message_loop
      WIN32OLE_EVENT.message_loop
      sleep 0.1
    end

    def setup
      WIN32OLE_EVENT.message_loop
      @ie = WIN32OLE.new("InternetExplorer.Application")
      message_loop
      @ie.visible = true
      message_loop
      @event = ""
      @event2 = ""
      @event3 = ""
      @f = create_temp_html
    end

    def default_handler(event, *args)
      @event += event
    end

    def test_s_new
      assert_raise(TypeError) {
        ev = WIN32OLE_EVENT.new("A")
      }
    end

    def test_s_new_without_itf
      ev = WIN32OLE_EVENT.new(@ie)
      ev.on_event {|*args| default_handler(*args)}
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        WIN32OLE_EVENT.new(@ie)
        GC.start  
        message_loop
      end
      assert_match(/BeforeNavigate/, @event)
      assert_match(/NavigateComplete/, @event)
    end

    def test_on_event
      ev = WIN32OLE_EVENT.new(@ie, 'DWebBrowserEvents')
      ev.on_event {|*args| default_handler(*args)}
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        WIN32OLE_EVENT.new(@ie, 'DWebBrowserEvents') 
        GC.start  
        message_loop
      end
      assert_match(/BeforeNavigate/, @event)
      assert_match(/NavigateComplete/, @event)
    end

    def test_on_event2
      ev = WIN32OLE_EVENT.new(@ie, 'DWebBrowserEvents')
      ev.on_event('BeforeNavigate') {|*args| handler1}
      ev.on_event('BeforeNavigate') {|*args| handler2}
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_equal("handler2", @event2)
    end

    def test_on_event3
      ev = WIN32OLE_EVENT.new(@ie, 'DWebBrowserEvents')
      ev.on_event {|*args| handler1}
      ev.on_event {|*args| handler2}
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_equal("handler2", @event2)
    end

    def test_on_event4
      ev = WIN32OLE_EVENT.new(@ie, 'DWebBrowserEvents')
      ev.on_event{|*args| handler1}
      ev.on_event{|*args| handler2}
      ev.on_event('NavigateComplete'){|*args| handler3(*args)}
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert(@event3!="")
      assert("handler2", @event2)
    end

    def test_on_event5
      ev = WIN32OLE_EVENT.new(@ie, 'DWebBrowserEvents')
      ev.on_event {|*args| default_handler(*args)}
      ev.on_event('NavigateComplete'){|*args| handler3(*args)}
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_match(/BeforeNavigate/, @event)
      assert(/NavigateComplete/ !~ @event)
      assert(@event!="")
    end

    def test_unadvise
      ev = WIN32OLE_EVENT.new(@ie, 'DWebBrowserEvents')
      ev.on_event {|*args| default_handler(*args)}
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_match(/BeforeNavigate/, @event)
      ev.unadvise
      @event = ""
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_equal("", @event);
      assert_raise(WIN32OLERuntimeError) {
        ev.on_event {|*args| default_handler(*args)}
      }
    end

    def test_non_exist_event
      assert_raise(RuntimeError) {
        ev = WIN32OLE_EVENT.new(@ie, 'XXXX')
      }
      dict = WIN32OLE.new('Scripting.Dictionary')
      assert_raise(RuntimeError) {
        ev = WIN32OLE_EVENT.new(dict)
      }
    end

    def test_on_event_with_outargs
      ev = WIN32OLE_EVENT.new(@ie)
      # ev.on_event_with_outargs('BeforeNavigate'){|*args|
      #  args.last[5] = true # Cancel = true
      # }
      ev.on_event_with_outargs('BeforeNavigate2'){|*args|
        args.last[6] = true # Cancel = true
      }
      bl = @ie.locationURL
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_equal(bl, @ie.locationURL)
    end

    def test_on_event_hash_return
      ev = WIN32OLE_EVENT.new(@ie)
      ev.on_event('BeforeNavigate2'){|*args|
        {:return => 1, :Cancel => true}
      }
      bl = @ie.locationURL
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_equal(bl, @ie.locationURL)
    end

    def test_on_event_hash_return2
      ev = WIN32OLE_EVENT.new(@ie)
      ev.on_event('BeforeNavigate2'){|*args|
        {:Cancel => true}
      }
      bl = @ie.locationURL
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_equal(bl, @ie.locationURL)
    end

    def test_on_event_hash_return3
      ev = WIN32OLE_EVENT.new(@ie)
      ev.on_event('BeforeNavigate2'){|*args|
        {'Cancel' => true}
      }
      bl = @ie.locationURL
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_equal(bl, @ie.locationURL)
    end
    
    def test_on_event_hash_return4
      ev = WIN32OLE_EVENT.new(@ie)
      ev.on_event('BeforeNavigate2'){|*args|
        {'return' => 2, 'Cancel' => true}
      }
      bl = @ie.locationURL
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_equal(bl, @ie.locationURL)
    end

    def test_on_event_hash_return5
      ev = WIN32OLE_EVENT.new(@ie)
      ev.on_event('BeforeNavigate2'){|*args|
        {6 => true}
      }
      bl = @ie.locationURL
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      assert_equal(bl, @ie.locationURL)
    end

    def test_off_event
      ev = WIN32OLE_EVENT.new(@ie)
      ev.on_event{handler1}
      ev.off_event
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      WIN32OLE_EVENT.message_loop
      assert_equal("", @event2)
    end

    def test_off_event_arg
      ev = WIN32OLE_EVENT.new(@ie)
      ev.on_event('BeforeNavigate2'){handler1}
      ev.off_event('BeforeNavigate2')
      @ie.navigate("file:///#{@f}")
      while @ie.busy
        message_loop
      end
      WIN32OLE_EVENT.message_loop
      assert_equal("", @event2)
    end

    def handler1
      @event2 = "handler1"
    end

    def handler2
      @event2 = "handler2"
    end

    def handler3(url)
      @event3 += url
    end

    def teardown
      @ie.quit
      @ie = nil
      i = 0
      begin 
        i += 1
        File.unlink(@f) if i < 10
      rescue Errno::EACCES
        message_loop
        retry
      end
      message_loop
      GC.start
      message_loop
    end
  end
end
