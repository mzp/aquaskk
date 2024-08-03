//
//  IMBridge.swift
//  Harness
//
//  Created by mzp on 8/2/24.
//

import Foundation
import AquaSKKIM

import InputMethodKit
import SwiftUI
import OSLog
import InputMethodKit

let logger = Logger(subsystem: "org.codefirst.AquaSKK", category: "Harness")

class IMKTextInputAdapter : NSObject, IMKTextInput {
    let textView:NSTextInputClient
    init(textView: NSTextView) {
        self.textView = textView
    }

    func insertText(_ string: Any, replacementRange: NSRange) {
        textView.insertText(string, replacementRange: replacementRange)
    }

    func setMarkedText(
        _ string: Any?,
        selectionRange: NSRange,
        replacementRange: NSRange
    ) {
        textView
            .setMarkedText(
                string ?? "",
                selectedRange: selectionRange,
                replacementRange: replacementRange
            )
    }

    func selectedRange() -> NSRange {
        textView.selectedRange()
    }

    func markedRange() -> NSRange {
        textView.markedRange()
    }

    func attributedSubstring(from range: NSRange) -> NSAttributedString! {
        textView.attributedSubstring(forProposedRange: range, actualRange: nil)
    }

    func length() -> Int {
        textView.attributedString?().length ?? 0
    }

    func characterIndex(for point: NSPoint, tracking mappingMode: IMKLocationToOffsetMappingMode, inMarkedRange: UnsafeMutablePointer<ObjCBool>!) -> Int {
        textView.characterIndex(for: point)
    }

    func attributes(forCharacterIndex index: Int, lineHeightRectangle lineRect: UnsafeMutablePointer<NSRect>!) -> [AnyHashable : Any]! {
        return [:]
    }

    func validAttributesForMarkedText() -> [Any]! {
        textView.validAttributesForMarkedText()
    }

    func overrideKeyboard(withKeyboardNamed keyboardUniqueName: String!) {
        logger.info("\(#function): \(keyboardUniqueName)")
    }

    func selectMode(_ modeIdentifier: String!) {
        logger.info("\(#function): \(modeIdentifier)")
    }

    func supportsUnicode() -> Bool {
        true
    }

    func bundleIdentifier() -> String! {
        Bundle.main.bundleIdentifier
    }

    func windowLevel() -> CGWindowLevel {
        0
    }

    func supportsProperty(_ property: TSMDocumentPropertyTag) -> Bool {
        logger.warning("\(#function): \(property)")
        return true
    }

    func uniqueClientIdentifierString() -> String! {
        "org.codefirst.AquaSKK.client"
    }

    func string(from range: NSRange, actualRange: NSRangePointer!) -> String! {
        textView
            .attributedSubstring(
                forProposedRange: range,
                actualRange: actualRange
            )?.string
    }

    func firstRect(forCharacterRange aRange: NSRange, actualRange: NSRangePointer!) -> NSRect {
        textView.firstRect(forCharacterRange: aRange, actualRange: actualRange)
    }

//    let textView: NSTextView
}


class IMTextViewImpl : NSTextView {
    struct Session {
        var client: IMKTextInput
        var controller: IMKInputController
    }
    private var session: Session?

    override func keyDown(with event: NSEvent) {
        let handled = session?.controller.handle(event, client: session?.client)
        if !(handled ?? false) {
            super.keyDown(with: event)
        }
    }

    override func flagsChanged(with event: NSEvent) {
/*        let handled = session?.controller.handle(event, client: session?.client)
        if !(handled ?? false) {
            super.flagsChanged(with: event)
        }*/
    }


    func activate() {
        let client = IMKTextInputAdapter(textView: self)
        let controller = SKKInputController(client: client)
        logger.info("client = \(client), controller = \(controller)")
        self.session = .init(
            client: client,
            controller: controller
        )

        controller.activateServer(self)
    }
}


struct IMTextView : NSViewRepresentable {
    func makeNSView(context: Context) -> NSTextView {
        let view = IMTextViewImpl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.activate()
        return view
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
    }
}

/*
 import Foundation

 /**
  @const        kIMKCommandMenuItem
  @abstract    An NSMenuItem in the infoDictionary passed to menu item actions.

  @discussion Use as a key to find the NSMenuItem in the infoDictionary.
  */
 public let kIMKCommandMenuItemName: String

 /**
  @const        kIMKCommandClient
  @abstract    A client object that conforms to the IMKInputText and NSObject protocols.

  @discussion Use as a key to find the client in the infoDictionary.
  */
 public let kIMKCommandClientName: String

 /**
  @protocol    IMKServerInput
  @abstract    Informal protocol which is used to send user events to an input method.
  @discussion  This is not a formal protocol by choice.  The reason for that is that there are three ways to receive events here. An input method should choose one of those ways and  implement the appropriate methods.

  Here are the three approaches:

  1.  Support keybinding.
  In this approach the system takes each keydown and trys to map the keydown to an action method that the input method has implemented.  If an action is found the system calls didCommandBySelector:client:.  If no action method is found inputText:client: is called.  An input method choosing this approach should implement
  -(BOOL)inputText:(NSString*)string client:(id)sender;
  -(BOOL)didCommandBySelector:(SEL)aSelector client:(id)sender;

  2. Receive all key events without the keybinding, but do "unpack" the relevant text data.
  Key events are broken down into the Unicodes, the key code that generated them, and modifier flags.  This data is then sent to the input method's inputText:key:modifiers:client: method.  For this approach implement:
  -(BOOL)inputText:(NSString*)string key:(NSInteger)keyCode modifiers:(NSUInteger)flags client:(id)sender;

  3. Receive events directly from the Text Services Manager as NSEvent objects.  For this approach implement:
  -(BOOL)handleEvent:(NSEvent*)event client:(id)sender;
  */
 extension NSObject {

 /**
  @method
  @abstract   Receive the Unicodes, the key code that generated them and modifier flags.
  @discussion Input methods implementing this method should return YES if the input was excepted, and NO if not excepted.
  */
 open func inputText(_ string: String!, key keyCode: Int, modifiers flags: Int, client sender: Any!) -> Bool

 /**
  @method
  @abstract   Each keydown that does not map to an action method is delivered to the input method as an NSString.
  @discussion If the input string is not excepted the input method should return NO.  When text is accepted return YES.  Input methods should implement this method when they are using keybinding (i.e. have implemented didCommandBySelector:client:).
  */
 open func inputText(_ string: String!, client sender: Any!) -> Bool

 /**
  @method
  @abstract   Receive all keydown and mouse events as an NSEvent (i.e. the event is simply forwarded onto the input method).
  @discussion Return YES if the event was handled. NO if not handled.
  */
 open func handle(_ event: NSEvent!, client sender: Any!) -> Bool

 /**
  @method
  @abstract   Called when system binds a keyDown event to an action method.
  @discussion This method is designed to return YES if the command is handled and NO if the command is not handled. It is called to process a command that was generated by user action such as typing certain keys or mousing down. It is necessary for this method to return YES or NO so the  event can be passed through to the client if it is not handled.  The selector can be an action specified in the input method's dictionary of keys and actions (i.e. an action specific to the input method) or one of the NSResponder action methods such as insertNewline: or deleteBackward:.  By definition such action methods do not return a value.  For that reason if you implement this method you should test if it is appropriate to call the action method before calling it since calling the action method is agreeing to handle the command

  For example.  Suppose you have implemented a version of insertNewline: that terminates the conversion session and sends the fully converted text to the client.  However, if you conversion buffer is empty you want the application to receive the return key that triggered the call to insertNewline:.  In that case when didCommandBySelector:client: is called you should test your buffer before calling your implementation of insertNewline:.  If the buffer is empty you would return NO indicating that the return key should be passed on to the application.  If the buffer is not empty you would call insertNewline: and then return YES as the result of didCommandBySelector:client:.
  */
 open func didCommand(by aSelector: Selector!, client sender: Any!) -> Bool

 /**
  @method
  @abstract   Return the current composed string.  This may be an NSString or NSAttributedString.

  A composed string refers to the buffer that an input method typically maintains to mirror the text contained in the active inline area.  It is called the composed string to reflect the fact that the input method composed the string by converting the characters input by the user.  In addition, using the term composed string makes it easier to differentiate between an input method's buffer and the text in the active inline area that the user sees. The returned object should be an autoreleased object.
  */
 open func composedString(_ sender: Any!) -> Any!

 /**
  @method
  @abstract   Return the a string consisting of the original pre-composition unicodes.
  @discussion If an input method stores the original input text it should return that text here.  The return value is an attributed string so that input method's can potentially restore changes they may have made to the font, etc.  The returned object should be an autoreleased object.
  */
 open func originalString(_ sender: Any!) -> NSAttributedString!

 /**
  @method
  @abstract   Called to inform the controller that the composition should be committed.
  @discussion If an input method implements this method it will be called when the client wishes to end the composition session immediately. A typical response would be to call the client's insertText method and then clean up any per-session buffers and variables.  After receiving this message an input method should consider the given composition session finished.
  */
 open func commitComposition(_ sender: Any!)

 /**
  @method
  @abstract   Called to get an array of candidates.
  @discussion An input method would look up its currently composed string and return a list of candidate strings that that string might map to. The returned NSArray should be an autoreleased object.


  */
 open func candidates(_ sender: Any!) -> [Any]!
 }

 /**
  @protocol    IMKStateSetting
  @abstract    This protocol sets or accesses values that indicate the state of an input method.
  */
 public protocol IMKStateSetting {

 /**
  @method
  @abstract   Activates the input method.
  */
 func activateServer(_ sender: Any!)

 /**
  @method
  @abstract   Deactivate the input method.
  */
 func deactivateServer(_ sender: Any!)

 /**
  @method
  @abstract   Return a object value whose key is tag.  The returned object should be autoreleased.
  */
 func value(forTag tag: Int, client sender: Any!) -> Any!

 /**
  @method
  @abstract   Set the tagged value to the object specified by value.
  */
 func setValue(_ value: Any!, forTag tag: Int, client sender: Any!)

 /**
  @method
  @abstract   This is called to obtain the input method's modes dictionary.
  @discussion Typically this is called to to build the text input menu.  By calling the input method rather than reading the modes from the info.plist the input method can dynamically modify he modes supported. The returned NSDictionary should be an autoreleased object.
  */
 func modes(_ sender: Any!) -> [AnyHashable : Any]!

 /**
  @method
  @abstract   Returns an unsigned integer containing a union of event masks (see NSEvent.h)
  @discussion A client will check with an input method to see if an event is supported by calling the method.  The default implementation returns NSKeyDownMask.
  If your input method only handles key downs the InputMethodKit provides default mouse handling.  The default mousedown handling behavior is as follows: if there is an active composition area and the user clicks in the text but outside of the composition area the InputMethodKit will send your input method a commitComposition: message. Note that this will only happen for input methods that return just NSKeyDownMask (i.e. the default value) as the result of recognizedEvents.
  */
 func recognizedEvents(_ sender: Any!) -> Int

 /**
  @method
  @abstract   Looks for a nib file containing a windowController class and a preferences utility. If found the panel is displayed.
  @discussion To use this method include a menu item whose action is showPreferences: in your input method's menu.  If that is done the method will be called automatically when a user selects the item in the Text Input Menu.
  The default implementation looks for a nib file called preferences.nib.  If found a windowController class is allocated and the nib is loaded.  You can provide a custom windowController class by naming the class in your input methods info.plist file.  To do that provide a string value that names the custom class with a key of InputMethodServerPreferencesWindowControllerClass.
  */
 func showPreferences(_ sender: Any!)
 }

 /**
  @protocol    IMKMouseHandling
  @abstract    This protocol receives mouse events.
  */
 public protocol IMKMouseHandling {

 /**
  @method

  @abstract   Sends a mouseDown to an input method.
  @discussion A mouse down event happened at given index within the sender� text storage, at the given point, and with modifier keys identified in flags. Return YES if handled.  Set keepTracking to YES if you want to receive subsequent mouseMoved and mouseUp events.
  */
 @available(macOS 10.0, *)
 func mouseDown(onCharacterIndex index: Int, coordinate point: NSPoint, withModifier flags: Int, continueTracking keepTracking: UnsafeMutablePointer<ObjCBool>!, client sender: Any!) -> Bool

 /**
  @method

  @abstract   Sends a mouseUp to an input method.
  @discussion A mouse up event happened at given index within the sender text view� text storage, at the given point, with modifier keys identified in flags. Return YES if handled.
  */
 func mouseUp(onCharacterIndex index: Int, coordinate point: NSPoint, withModifier flags: Int, client sender: Any!) -> Bool

 /**
  @method

  @abstract   Passes a mouseMoved event to the input method.
  @discussion A mouse moved event happened at given index within the sender text view� text storage, at the given point, with modifier keys identified in flags. Return YES if handled.
  */
 func mouseMoved(onCharacterIndex index: Int, coordinate point: NSPoint, withModifier flags: Int, client sender: Any!) -> Bool
 }

 /**
  @class      IMKInputController
  @abstract    The basic class that controls input on the input method side.
  @discussion  IMKInputController implements fully implements the protocols defined above.  Typically a developer does not override this class, but provides a delegate object that implements the methods that developer is interested in.  The IMKInputController versions of the protocol methods check if the delegate object implements a method, and  call the delegate version if it exists.

  The IMKServer class which is allocated in an input method's main function creates a controller class for each input session created by a client application. Therefore for every input session there is a corresponding IMKInputController.
  */
 open class IMKInputController : NSObject, IMKStateSetting, IMKMouseHandling {

 /**
  @method
  @abstract   Initializes the controller class setting the delegate.

  The inputClient parameter is the client side object that will be sending messages to the controller via the IMKServer.  The client object always conforms to the IMKTextInput protocol.

  Methods in the protocols that are implemented by the delegate object always include a client parameter.  Methods in the IMKInputController class do not take a client.  This is because the client is stored as an ivar in the IMKInputController.
  */
 public init!(server: IMKServer!, delegate: Any!, client inputClient: Any!)

 /**
  @method
  @abstract   Called to inform the controller that the composition has changed.
  @discussion This method will call the protocol method composedString: to obtain the current composition. The current composition will be sent to the client by a call to the method setMarkedText:
  */
 open func updateComposition()

 /**
  @method
  @abstract   Stops the current composition and replaces marked text with the original text.
  @discussion Calls the method originalString to obtain the original text and sends that to the client via a call to IMKInputSession protocol method insertText:
  */
 open func cancelComposition()

 /**
  @method
  @abstract   Called to obtain a dictionary of text attributes.
  @discussion The default implementation returns an empty dictionary.  You should override this method if your input method wants to provide font or glyphInformation. The returned object should be an autoreleased object.
  */
 open func compositionAttributes(at range: NSRange) -> NSMutableDictionary!

 /**
  @method
  @abstract   Returns where the selection should be placed inside markedText.
  @discussion This method is called by updateComposition: to obtain the selection range for markedText.  The default implementation sets the selection range at the end of the marked text.
  */
 open func selectionRange() -> NSRange

 /**
  @method
  @abstract   Returns the range in the client document that text should replace.
  @discussion This method is called by updateComposition to obtain the range in the client's document where markedText should be placed.  The default implementation returns an NSRange whose location and length are NSNotFound.  That indicates that the marked text should be placed at the current insertion point.  Input methods that wish to insert marked text somewhere other than at the current insertion point should override this method.

  An example of an input method that might override this method would be one replaced words with synonyms.  That input method would watch for certain words and when one of those words was seen it would be replaced by marked text that was a synonym of the word.
  */
 open func replacementRange() -> NSRange

 /**
  @method
  @abstract   Returns a dictionary of text attributes that can be used to mark a range of an attributed string that is going to be sent to a client.
  @discussion This utility function can be called by input methods to mark each range (i.e. clause ) of marked text.  The style parameter should be one of the following values: kTSMHiliteSelectedRawText, kTSMHiliteConvertedText or kTSMHiliteSelectedConvertedText. See AERegistry.h for the definition of these values.

  The default implementation begins by calling compositionAttributesAtRange: to obtain extra attributes that an input method wants to include such as font or  glyph information.  Then the appropriate underline and underline color information is added to the attributes dictionary for the style parameter.

  Finally the style value is added as dictionary value.  The key for the style value is NSMarkedClauseSegment. The returned object should be an autoreleased object.
  */
 open func mark(forStyle style: Int, at range: NSRange) -> [AnyHashable : Any]!

 /**
  @method
  @abstract   Called to pass commands that are not generated as part of the text input.
  @discussion The default implementation checks if the controller object (i.e. self) responds to the selector.  If that is true the message performSelector:withObject  is sent to the controller class.  The object parameter in that case is the infoDictionary.

  This method is called when a user selects a command item from the text input menu.  To support this an input method merely needs to provide actions for each menu item that will be placed in the menu.

  i.e. -(void)menuAction:(id)sender

  Note that the sender in this instance will be the infoDictionary.  The dictionary contains two values:

  kIMKCommandMenuItemName            NSMenuItem  -- the NSMenuItem that was selected
  kIMKCommandClientName            id<IMKTextInput, NSObject> - the current client
  */
 open func doCommand(by aSelector: Selector!, command infoDictionary: [AnyHashable : Any]!)

 /**
  @method
  @abstract   Called to inform an input method that any visible UI should be closed.
  */
 open func hidePalettes()

 /**
  @method
  @abstract   Returns a menu of input method specific commands.
  @discussion This method is called whenever the menu needs to be drawn so that input methods can update the menu to reflect their current state. The returned NSMenu is an autoreleased object.
  */
 open func menu() -> NSMenu!

 /**
  @method     - (id)delegate;
  @abstract   Returns the input controller's delegate object. The returned id is an autoreleased object.
  */
 open func delegate() -> Any!

 /**
  @method
  @abstract   Set the input controller's delegate object.
  */
 open func setDelegate(_ newDelegate: Any!)

 /**
  @method
  @abstract   Return the server object which is managing this input controller. The returned IMKServer is an autoreleased object.
  */
 open func server() -> IMKServer!

 /**
  @method
  @abstract   Returns this controller's client object.
  @discussion The client object will conform to the IMKTextInput protocol. The returned object is an autoreleased object.
  */
 open func client() -> (any IMKTextInput & NSObjectProtocol)!

 /**
  @method
  @abstract   Called to notify an input controller that it is about to be closed.
  */
 @available(macOS 10.7, *)
 open func inputControllerWillClose()

 /**
  @method
  @abstract   Called when a user has selected a annotation in a candidate window.
  @discussion When a candidate window is displayed and the user selects an annotation the selected annotation is sent to the input controller via this method.  The currently selected candidateString is also sent to the input method.
  */
 open func annotationSelected(_ annotationString: NSAttributedString!, forCandidate candidateString: NSAttributedString!)

 /**
  @method
  @abstract   Informs an input controller that the current candidate selection in the candidate window has changed.
  @discussion The candidate parameter is the candidate string that the selection changed to.  Note this method is called to indicate that the user is moving around in the candidate window.  The candidate object is not a final selection.
  */
 open func candidateSelectionChanged(_ candidateString: NSAttributedString!)

 /**
  @method
  @abstract   Called when a new candidate has been finally selected.
  @discussion The candidate parameter is the users final choice from the candidate window. The candidate window will have been closed before this method is called.
  */
 open func candidateSelected(_ candidateString: NSAttributedString!)
 }


 */
