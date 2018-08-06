# Safari-Windows
My first Cocoa proggy on macOS Quite raw but doing what it should.
it's an example of <br>
<strong>programmatically scripting application</strong> and 
<strong>using NSOutlineView</strong>

The idea is to find a (hidden somewhere) Safari Window and relevant Tab. I hat this idea a long time ago, due to my huge (40") screen and many spaces. 
The challenges:
- find them all
- show in hierearchicalview: Window -> tab
- on request activate selected tab
- quit the app

To find tabs I used Swift Scripting Framework of TONY INGRALDI which can be found on GitHub <a href="https://github.com/tingraldi/SwiftScripting">here</a>. Helped a lot as I do not know any technology on Mac 
similar to COM on Windows.

Activations is done by scripting as well.

Quit by pressing a button is for me a bit tricky: ViewController has a property which is set by WindowController 
to a call close() of the window.  

More or less 5 days to learn Xcode, to read properly Apple documentation and find out other things which whole world obviously knows but I do not.
