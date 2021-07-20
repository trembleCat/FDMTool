/*
 * Copyright (c) 1999-2007 Apple Inc.  All Rights Reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_LICENSE_HEADER_END@
 */

/* Types */

/// An opaque type that represents a method in a class definition.
public typealias Method = OpaquePointer

/// An opaque type that represents an instance variable.
public typealias Ivar = OpaquePointer

/// An opaque type that represents a category.
public typealias Category = OpaquePointer

/// An opaque type that represents an Objective-C declared property.
public typealias objc_property_t = OpaquePointer

/* Use `Class` instead of `struct objc_class *` */

public class Protocol {
}

/// Defines a method
public struct objc_method_description {

    /**< The name of the method */
    public var name: Selector?

    /**< The types of the method arguments */
    public var types: UnsafeMutablePointer<CChar>?

    public init()

    public init(name: Selector?, types: UnsafeMutablePointer<CChar>?)
}

/// Defines a property attribute
public struct objc_property_attribute_t {

    /**< The name of the attribute */
    public var name: UnsafePointer<CChar>

    /**< The value of the attribute (usually empty) */
    public var value: UnsafePointer<CChar>

    public init(name: UnsafePointer<CChar>, value: UnsafePointer<CChar>)
}

/* Functions */

/* Working with Instances */

/**
 * Returns a copy of a given object.
 *
 * @param obj An Objective-C object.
 * @param size The size of the object \e obj.
 *
 * @return A copy of \e obj.
 */

/**
 * Frees the memory occupied by a given object.
 *
 * @param obj An Objective-C object.
 *
 * @return nil
 */

/**
 * Returns the class of an object.
 *
 * @param obj The object you want to inspect.
 *
 * @return The class object of which \e object is an instance,
 *  or \c Nil if \e object is \c nil.
 */
@available(iOS 2.0, *)
public func object_getClass(_ obj: Any?) -> AnyClass?

/**
 * Sets the class of an object.
 *
 * @param obj The object to modify.
 * @param cls A class object.
 *
 * @return The previous value of \e object's class, or \c Nil if \e object is \c nil.
 */
@available(iOS 2.0, *)
public func object_setClass(_ obj: Any?, _ cls: AnyClass) -> AnyClass?

/**
 * Returns whether an object is a class object.
 *
 * @param obj An Objective-C object.
 *
 * @return true if the object is a class or metaclass, false otherwise.
 */
@available(iOS 8.0, *)
public func object_isClass(_ obj: Any?) -> Bool

/**
 * Reads the value of an instance variable in an object.
 *
 * @param obj The object containing the instance variable whose value you want to read.
 * @param ivar The Ivar describing the instance variable whose value you want to read.
 *
 * @return The value of the instance variable specified by \e ivar, or \c nil if \e object is \c nil.
 *
 * @note \c object_getIvar is faster than \c object_getInstanceVariable if the Ivar
 *  for the instance variable is already known.
 */
@available(iOS 2.0, *)
public func object_getIvar(_ obj: Any?, _ ivar: Ivar) -> Any?

/**
 * Sets the value of an instance variable in an object.
 *
 * @param obj The object containing the instance variable whose value you want to set.
 * @param ivar The Ivar describing the instance variable whose value you want to set.
 * @param value The new value for the instance variable.
 *
 * @note Instance variables with known memory management (such as ARC strong and weak)
 *  use that memory management. Instance variables with unknown memory management
 *  are assigned as if they were unsafe_unretained.
 * @note \c object_setIvar is faster than \c object_setInstanceVariable if the Ivar
 *  for the instance variable is already known.
 */
@available(iOS 2.0, *)
public func object_setIvar(_ obj: Any?, _ ivar: Ivar, _ value: Any?)

/**
 * Sets the value of an instance variable in an object.
 *
 * @param obj The object containing the instance variable whose value you want to set.
 * @param ivar The Ivar describing the instance variable whose value you want to set.
 * @param value The new value for the instance variable.
 *
 * @note Instance variables with known memory management (such as ARC strong and weak)
 *  use that memory management. Instance variables with unknown memory management
 *  are assigned as if they were strong.
 * @note \c object_setIvar is faster than \c object_setInstanceVariable if the Ivar
 *  for the instance variable is already known.
 */
@available(iOS 10.0, *)
public func object_setIvarWithStrongDefault(_ obj: Any?, _ ivar: Ivar, _ value: Any?)

/**
 * Changes the value of an instance variable of a class instance.
 *
 * @param obj A pointer to an instance of a class. Pass the object containing
 *  the instance variable whose value you wish to modify.
 * @param name A C string. Pass the name of the instance variable whose value you wish to modify.
 * @param value The new value for the instance variable.
 *
 * @return A pointer to the \c Ivar data structure that defines the type and
 *  name of the instance variable specified by \e name.
 *
 * @note Instance variables with known memory management (such as ARC strong and weak)
 *  use that memory management. Instance variables with unknown memory management
 *  are assigned as if they were unsafe_unretained.
 */

/**
 * Changes the value of an instance variable of a class instance.
 *
 * @param obj A pointer to an instance of a class. Pass the object containing
 *  the instance variable whose value you wish to modify.
 * @param name A C string. Pass the name of the instance variable whose value you wish to modify.
 * @param value The new value for the instance variable.
 *
 * @return A pointer to the \c Ivar data structure that defines the type and
 *  name of the instance variable specified by \e name.
 *
 * @note Instance variables with known memory management (such as ARC strong and weak)
 *  use that memory management. Instance variables with unknown memory management
 *  are assigned as if they were strong.
 */

/**
 * Obtains the value of an instance variable of a class instance.
 *
 * @param obj A pointer to an instance of a class. Pass the object containing
 *  the instance variable whose value you wish to obtain.
 * @param name A C string. Pass the name of the instance variable whose value you wish to obtain.
 * @param outValue On return, contains a pointer to the value of the instance variable.
 *
 * @return A pointer to the \c Ivar data structure that defines the type and name of
 *  the instance variable specified by \e name.
 */

/* Obtaining Class Definitions */

/**
 * Returns the class definition of a specified class.
 *
 * @param name The name of the class to look up.
 *
 * @return The Class object for the named class, or \c nil
 *  if the class is not registered with the Objective-C runtime.
 *
 * @note \c objc_getClass is different from \c objc_lookUpClass in that if the class
 *  is not registered, \c objc_getClass calls the class handler callback and then checks
 *  a second time to see whether the class is registered. \c objc_lookUpClass does
 *  not call the class handler callback.
 *
 * @warning Earlier implementations of this function (prior to OS X v10.0)
 *  terminate the program if the class does not exist.
 */
@available(iOS 2.0, *)
public func objc_getClass(_ name: UnsafePointer<CChar>) -> Any!

/**
 * Returns the metaclass definition of a specified class.
 *
 * @param name The name of the class to look up.
 *
 * @return The \c Class object for the metaclass of the named class, or \c nil if the class
 *  is not registered with the Objective-C runtime.
 *
 * @note If the definition for the named class is not registered, this function calls the class handler
 *  callback and then checks a second time to see if the class is registered. However, every class
 *  definition must have a valid metaclass definition, and so the metaclass definition is always returned,
 *  whether it’s valid or not.
 */
@available(iOS 2.0, *)
public func objc_getMetaClass(_ name: UnsafePointer<CChar>) -> Any!

/**
 * Returns the class definition of a specified class.
 *
 * @param name The name of the class to look up.
 *
 * @return The Class object for the named class, or \c nil if the class
 *  is not registered with the Objective-C runtime.
 *
 * @note \c objc_getClass is different from this function in that if the class is not
 *  registered, \c objc_getClass calls the class handler callback and then checks a second
 *  time to see whether the class is registered. This function does not call the class handler callback.
 */
@available(iOS 2.0, *)
public func objc_lookUpClass(_ name: UnsafePointer<CChar>) -> AnyClass?

/**
 * Returns the class definition of a specified class.
 *
 * @param name The name of the class to look up.
 *
 * @return The Class object for the named class.
 *
 * @note This function is the same as \c objc_getClass, but kills the process if the class is not found.
 * @note This function is used by ZeroLink, where failing to find a class would be a compile-time link error without ZeroLink.
 */
@available(iOS 2.0, *)
public func objc_getRequiredClass(_ name: UnsafePointer<CChar>) -> AnyClass

/**
 * Obtains the list of registered class definitions.
 *
 * @param buffer An array of \c Class values. On output, each \c Class value points to
 *  one class definition, up to either \e bufferCount or the total number of registered classes,
 *  whichever is less. You can pass \c NULL to obtain the total number of registered class
 *  definitions without actually retrieving any class definitions.
 * @param bufferCount An integer value. Pass the number of pointers for which you have allocated space
 *  in \e buffer. On return, this function fills in only this number of elements. If this number is less
 *  than the number of registered classes, this function returns an arbitrary subset of the registered classes.
 *
 * @return An integer value indicating the total number of registered classes.
 *
 * @note The Objective-C runtime library automatically registers all the classes defined in your source code.
 *  You can create class definitions at runtime and register them with the \c objc_addClass function.
 *
 * @warning You cannot assume that class objects you get from this function are classes that inherit from \c NSObject,
 *  so you cannot safely call any methods on such classes without detecting that the method is implemented first.
 */
@available(iOS 2.0, *)
public func objc_getClassList(_ buffer: AutoreleasingUnsafeMutablePointer<AnyClass>?, _ bufferCount: Int32) -> Int32

/**
 * Creates and returns a list of pointers to all registered class definitions.
 *
 * @param outCount An integer pointer used to store the number of classes returned by
 *  this function in the list. It can be \c nil.
 *
 * @return A nil terminated array of classes. It must be freed with \c free().
 *
 * @see objc_getClassList
 */
@available(iOS 3.1, *)
public func objc_copyClassList(_ outCount: UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<AnyClass>?

/* Working with Classes */

/**
 * Returns the name of a class.
 *
 * @param cls A class object.
 *
 * @return The name of the class, or the empty string if \e cls is \c Nil.
 */
@available(iOS 2.0, *)
public func class_getName(_ cls: AnyClass?) -> UnsafePointer<CChar>

/**
 * Returns a Boolean value that indicates whether a class object is a metaclass.
 *
 * @param cls A class object.
 *
 * @return \c YES if \e cls is a metaclass, \c NO if \e cls is a non-meta class,
 *  \c NO if \e cls is \c Nil.
 */
@available(iOS 2.0, *)
public func class_isMetaClass(_ cls: AnyClass?) -> Bool

/**
 * Returns the superclass of a class.
 *
 * @param cls A class object.
 *
 * @return The superclass of the class, or \c Nil if
 *  \e cls is a root class, or \c Nil if \e cls is \c Nil.
 *
 * @note You should usually use \c NSObject's \c superclass method instead of this function.
 */
@available(iOS 2.0, *)
public func class_getSuperclass(_ cls: AnyClass?) -> AnyClass?

/**
 * Sets the superclass of a given class.
 *
 * @param cls The class whose superclass you want to set.
 * @param newSuper The new superclass for cls.
 *
 * @return The old superclass for cls.
 *
 * @warning You should not use this function.
 */

/**
 * Returns the version number of a class definition.
 *
 * @param cls A pointer to a \c Class data structure. Pass
 *  the class definition for which you wish to obtain the version.
 *
 * @return An integer indicating the version number of the class definition.
 *
 * @see class_setVersion
 */
@available(iOS 2.0, *)
public func class_getVersion(_ cls: AnyClass?) -> Int32

/**
 * Sets the version number of a class definition.
 *
 * @param cls A pointer to an Class data structure.
 *  Pass the class definition for which you wish to set the version.
 * @param version An integer. Pass the new version number of the class definition.
 *
 * @note You can use the version number of the class definition to provide versioning of the
 *  interface that your class represents to other classes. This is especially useful for object
 *  serialization (that is, archiving of the object in a flattened form), where it is important to
 *  recognize changes to the layout of the instance variables in different class-definition versions.
 * @note Classes derived from the Foundation framework \c NSObject class can set the class-definition
 *  version number using the \c setVersion: class method, which is implemented using the \c class_setVersion function.
 */
@available(iOS 2.0, *)
public func class_setVersion(_ cls: AnyClass?, _ version: Int32)

/**
 * Returns the size of instances of a class.
 *
 * @param cls A class object.
 *
 * @return The size in bytes of instances of the class \e cls, or \c 0 if \e cls is \c Nil.
 */
@available(iOS 2.0, *)
public func class_getInstanceSize(_ cls: AnyClass?) -> Int

/**
 * Returns the \c Ivar for a specified instance variable of a given class.
 *
 * @param cls The class whose instance variable you wish to obtain.
 * @param name The name of the instance variable definition to obtain.
 *
 * @return A pointer to an \c Ivar data structure containing information about
 *  the instance variable specified by \e name.
 */
@available(iOS 2.0, *)
public func class_getInstanceVariable(_ cls: AnyClass?, _ name: UnsafePointer<CChar>) -> Ivar?

/**
 * Returns the Ivar for a specified class variable of a given class.
 *
 * @param cls The class definition whose class variable you wish to obtain.
 * @param name The name of the class variable definition to obtain.
 *
 * @return A pointer to an \c Ivar data structure containing information about the class variable specified by \e name.
 */
@available(iOS 2.0, *)
public func class_getClassVariable(_ cls: AnyClass?, _ name: UnsafePointer<CChar>) -> Ivar?

/**
 * Describes the instance variables declared by a class.
 *
 * @param cls The class to inspect.
 * @param outCount On return, contains the length of the returned array.
 *  If outCount is NULL, the length is not returned.
 *
 * @return An array of pointers of type Ivar describing the instance variables declared by the class.
 *  Any instance variables declared by superclasses are not included. The array contains *outCount
 *  pointers followed by a NULL terminator. You must free the array with free().
 *
 *  If the class declares no instance variables, or cls is Nil, NULL is returned and *outCount is 0.
 */
@available(iOS 2.0, *)
public func class_copyIvarList(_ cls: AnyClass?, _ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<Ivar>?

/**
 * Returns a specified instance method for a given class.
 *
 * @param cls The class you want to inspect.
 * @param name The selector of the method you want to retrieve.
 *
 * @return The method that corresponds to the implementation of the selector specified by
 *  \e name for the class specified by \e cls, or \c NULL if the specified class or its
 *  superclasses do not contain an instance method with the specified selector.
 *
 * @note This function searches superclasses for implementations, whereas \c class_copyMethodList does not.
 */
@available(iOS 2.0, *)
public func class_getInstanceMethod(_ cls: AnyClass?, _ name: Selector) -> Method?

/**
 * Returns a pointer to the data structure describing a given class method for a given class.
 *
 * @param cls A pointer to a class definition. Pass the class that contains the method you want to retrieve.
 * @param name A pointer of type \c SEL. Pass the selector of the method you want to retrieve.
 *
 * @return A pointer to the \c Method data structure that corresponds to the implementation of the
 *  selector specified by aSelector for the class specified by aClass, or NULL if the specified
 *  class or its superclasses do not contain an instance method with the specified selector.
 *
 * @note Note that this function searches superclasses for implementations,
 *  whereas \c class_copyMethodList does not.
 */
@available(iOS 2.0, *)
public func class_getClassMethod(_ cls: AnyClass?, _ name: Selector) -> Method?

/**
 * Returns the function pointer that would be called if a
 * particular message were sent to an instance of a class.
 *
 * @param cls The class you want to inspect.
 * @param name A selector.
 *
 * @return The function pointer that would be called if \c [object name] were called
 *  with an instance of the class, or \c NULL if \e cls is \c Nil.
 *
 * @note \c class_getMethodImplementation may be faster than \c method_getImplementation(class_getInstanceMethod(cls, name)).
 * @note The function pointer returned may be a function internal to the runtime instead of
 *  an actual method implementation. For example, if instances of the class do not respond to
 *  the selector, the function pointer returned will be part of the runtime's message forwarding machinery.
 */
@available(iOS 2.0, *)
public func class_getMethodImplementation(_ cls: AnyClass?, _ name: Selector) -> IMP?

/**
 * Returns the function pointer that would be called if a particular
 * message were sent to an instance of a class.
 *
 * @param cls The class you want to inspect.
 * @param name A selector.
 *
 * @return The function pointer that would be called if \c [object name] were called
 *  with an instance of the class, or \c NULL if \e cls is \c Nil.
 */

/**
 * Returns a Boolean value that indicates whether instances of a class respond to a particular selector.
 *
 * @param cls The class you want to inspect.
 * @param sel A selector.
 *
 * @return \c YES if instances of the class respond to the selector, otherwise \c NO.
 *
 * @note You should usually use \c NSObject's \c respondsToSelector: or \c instancesRespondToSelector:
 *  methods instead of this function.
 */
@available(iOS 2.0, *)
public func class_respondsToSelector(_ cls: AnyClass?, _ sel: Selector) -> Bool

/**
 * Describes the instance methods implemented by a class.
 *
 * @param cls The class you want to inspect.
 * @param outCount On return, contains the length of the returned array.
 *  If outCount is NULL, the length is not returned.
 *
 * @return An array of pointers of type Method describing the instance methods
 *  implemented by the class—any instance methods implemented by superclasses are not included.
 *  The array contains *outCount pointers followed by a NULL terminator. You must free the array with free().
 *
 *  If cls implements no instance methods, or cls is Nil, returns NULL and *outCount is 0.
 *
 * @note To get the class methods of a class, use \c class_copyMethodList(object_getClass(cls), &count).
 * @note To get the implementations of methods that may be implemented by superclasses,
 *  use \c class_getInstanceMethod or \c class_getClassMethod.
 */
@available(iOS 2.0, *)
public func class_copyMethodList(_ cls: AnyClass?, _ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<Method>?

/**
 * Returns a Boolean value that indicates whether a class conforms to a given protocol.
 *
 * @param cls The class you want to inspect.
 * @param protocol A protocol.
 *
 * @return YES if cls conforms to protocol, otherwise NO.
 *
 * @note You should usually use NSObject's conformsToProtocol: method instead of this function.
 */
@available(iOS 2.0, *)
public func class_conformsToProtocol(_ cls: AnyClass?, _ protocol: Protocol?) -> Bool

/**
 * Describes the protocols adopted by a class.
 *
 * @param cls The class you want to inspect.
 * @param outCount On return, contains the length of the returned array.
 *  If outCount is NULL, the length is not returned.
 *
 * @return An array of pointers of type Protocol* describing the protocols adopted
 *  by the class. Any protocols adopted by superclasses or other protocols are not included.
 *  The array contains *outCount pointers followed by a NULL terminator. You must free the array with free().
 *
 *  If cls adopts no protocols, or cls is Nil, returns NULL and *outCount is 0.
 */
@available(iOS 2.0, *)
public func class_copyProtocolList(_ cls: AnyClass?, _ outCount: UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<Protocol>?

/**
 * Returns a property with a given name of a given class.
 *
 * @param cls The class you want to inspect.
 * @param name The name of the property you want to inspect.
 *
 * @return A pointer of type \c objc_property_t describing the property, or
 *  \c NULL if the class does not declare a property with that name,
 *  or \c NULL if \e cls is \c Nil.
 */
@available(iOS 2.0, *)
public func class_getProperty(_ cls: AnyClass?, _ name: UnsafePointer<CChar>) -> objc_property_t?

/**
 * Describes the properties declared by a class.
 *
 * @param cls The class you want to inspect.
 * @param outCount On return, contains the length of the returned array.
 *  If \e outCount is \c NULL, the length is not returned.
 *
 * @return An array of pointers of type \c objc_property_t describing the properties
 *  declared by the class. Any properties declared by superclasses are not included.
 *  The array contains \c *outCount pointers followed by a \c NULL terminator. You must free the array with \c free().
 *
 *  If \e cls declares no properties, or \e cls is \c Nil, returns \c NULL and \c *outCount is \c 0.
 */
@available(iOS 2.0, *)
public func class_copyPropertyList(_ cls: AnyClass?, _ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_property_t>?

/**
 * Returns a description of the \c Ivar layout for a given class.
 *
 * @param cls The class to inspect.
 *
 * @return A description of the \c Ivar layout for \e cls.
 */
@available(iOS 2.0, *)
public func class_getIvarLayout(_ cls: AnyClass?) -> UnsafePointer<UInt8>?

/**
 * Returns a description of the layout of weak Ivars for a given class.
 *
 * @param cls The class to inspect.
 *
 * @return A description of the layout of the weak \c Ivars for \e cls.
 */
@available(iOS 2.0, *)
public func class_getWeakIvarLayout(_ cls: AnyClass?) -> UnsafePointer<UInt8>?

/**
 * Adds a new method to a class with a given name and implementation.
 *
 * @param cls The class to which to add a method.
 * @param name A selector that specifies the name of the method being added.
 * @param imp A function which is the implementation of the new method. The function must take at least two arguments—self and _cmd.
 * @param types An array of characters that describe the types of the arguments to the method.
 *
 * @return YES if the method was added successfully, otherwise NO
 *  (for example, the class already contains a method implementation with that name).
 *
 * @note class_addMethod will add an override of a superclass's implementation,
 *  but will not replace an existing implementation in this class.
 *  To change an existing implementation, use method_setImplementation.
 */
@available(iOS 2.0, *)
public func class_addMethod(_ cls: AnyClass?, _ name: Selector, _ imp: IMP, _ types: UnsafePointer<CChar>?) -> Bool

/**
 * Replaces the implementation of a method for a given class.
 *
 * @param cls The class you want to modify.
 * @param name A selector that identifies the method whose implementation you want to replace.
 * @param imp The new implementation for the method identified by name for the class identified by cls.
 * @param types An array of characters that describe the types of the arguments to the method.
 *  Since the function must take at least two arguments—self and _cmd, the second and third characters
 *  must be “@:” (the first character is the return type).
 *
 * @return The previous implementation of the method identified by \e name for the class identified by \e cls.
 *
 * @note This function behaves in two different ways:
 *  - If the method identified by \e name does not yet exist, it is added as if \c class_addMethod were called.
 *    The type encoding specified by \e types is used as given.
 *  - If the method identified by \e name does exist, its \c IMP is replaced as if \c method_setImplementation were called.
 *    The type encoding specified by \e types is ignored.
 */
@available(iOS 2.0, *)
public func class_replaceMethod(_ cls: AnyClass?, _ name: Selector, _ imp: IMP, _ types: UnsafePointer<CChar>?) -> IMP?

/**
 * Adds a new instance variable to a class.
 *
 * @return YES if the instance variable was added successfully, otherwise NO
 *         (for example, the class already contains an instance variable with that name).
 *
 * @note This function may only be called after objc_allocateClassPair and before objc_registerClassPair.
 *       Adding an instance variable to an existing class is not supported.
 * @note The class must not be a metaclass. Adding an instance variable to a metaclass is not supported.
 * @note The instance variable's minimum alignment in bytes is 1<<align. The minimum alignment of an instance
 *       variable depends on the ivar's type and the machine architecture.
 *       For variables of any pointer type, pass log2(sizeof(pointer_type)).
 */
@available(iOS 2.0, *)
public func class_addIvar(_ cls: AnyClass?, _ name: UnsafePointer<CChar>, _ size: Int, _ alignment: UInt8, _ types: UnsafePointer<CChar>?) -> Bool

/**
 * Adds a protocol to a class.
 *
 * @param cls The class to modify.
 * @param protocol The protocol to add to \e cls.
 *
 * @return \c YES if the method was added successfully, otherwise \c NO
 *  (for example, the class already conforms to that protocol).
 */
@available(iOS 2.0, *)
public func class_addProtocol(_ cls: AnyClass?, _ protocol: Protocol) -> Bool

/**
 * Adds a property to a class.
 *
 * @param cls The class to modify.
 * @param name The name of the property.
 * @param attributes An array of property attributes.
 * @param attributeCount The number of attributes in \e attributes.
 *
 * @return \c YES if the property was added successfully, otherwise \c NO
 *  (for example, the class already has that property).
 */
@available(iOS 4.3, *)
public func class_addProperty(_ cls: AnyClass?, _ name: UnsafePointer<CChar>, _ attributes: UnsafePointer<objc_property_attribute_t>?, _ attributeCount: UInt32) -> Bool

/**
 * Replace a property of a class.
 *
 * @param cls The class to modify.
 * @param name The name of the property.
 * @param attributes An array of property attributes.
 * @param attributeCount The number of attributes in \e attributes.
 */
@available(iOS 4.3, *)
public func class_replaceProperty(_ cls: AnyClass?, _ name: UnsafePointer<CChar>, _ attributes: UnsafePointer<objc_property_attribute_t>?, _ attributeCount: UInt32)

/**
 * Sets the Ivar layout for a given class.
 *
 * @param cls The class to modify.
 * @param layout The layout of the \c Ivars for \e cls.
 */
@available(iOS 2.0, *)
public func class_setIvarLayout(_ cls: AnyClass?, _ layout: UnsafePointer<UInt8>?)

/**
 * Sets the layout for weak Ivars for a given class.
 *
 * @param cls The class to modify.
 * @param layout The layout of the weak Ivars for \e cls.
 */
@available(iOS 2.0, *)
public func class_setWeakIvarLayout(_ cls: AnyClass?, _ layout: UnsafePointer<UInt8>?)

/**
 * Used by CoreFoundation's toll-free bridging.
 * Return the id of the named class.
 *
 * @return The id of the named class, or an uninitialized class
 *  structure that will be used for the class when and if it does
 *  get loaded.
 *
 * @warning Do not call this function yourself.
 */

/* Instantiating Classes */

/**
 * Creates an instance of a class, allocating memory for the class in the
 * default malloc memory zone.
 *
 * @param cls The class that you wish to allocate an instance of.
 * @param extraBytes An integer indicating the number of extra bytes to allocate.
 *  The additional bytes can be used to store additional instance variables beyond
 *  those defined in the class definition.
 *
 * @return An instance of the class \e cls.
 */
@available(iOS 2.0, *)
public func class_createInstance(_ cls: AnyClass?, _ extraBytes: Int) -> Any?

/**
 * Creates an instance of a class at the specific location provided.
 *
 * @param cls The class that you wish to allocate an instance of.
 * @param bytes The location at which to allocate an instance of \e cls.
 *  Must point to at least \c class_getInstanceSize(cls) bytes of well-aligned,
 *  zero-filled memory.
 *
 * @return \e bytes on success, \c nil otherwise. (For example, \e cls or \e bytes
 *  might be \c nil)
 *
 * @see class_createInstance
 */

/**
 * Destroys an instance of a class without freeing memory and removes any
 * associated references this instance might have had.
 *
 * @param obj The class instance to destroy.
 *
 * @return \e obj. Does nothing if \e obj is nil.
 *
 * @note CF and other clients do call this under GC.
 */

/* Adding Classes */

/**
 * Creates a new class and metaclass.
 *
 * @param superclass The class to use as the new class's superclass, or \c Nil to create a new root class.
 * @param name The string to use as the new class's name. The string will be copied.
 * @param extraBytes The number of bytes to allocate for indexed ivars at the end of
 *  the class and metaclass objects. This should usually be \c 0.
 *
 * @return The new class, or Nil if the class could not be created (for example, the desired name is already in use).
 *
 * @note You can get a pointer to the new metaclass by calling \c object_getClass(newClass).
 * @note To create a new class, start by calling \c objc_allocateClassPair.
 *  Then set the class's attributes with functions like \c class_addMethod and \c class_addIvar.
 *  When you are done building the class, call \c objc_registerClassPair. The new class is now ready for use.
 * @note Instance methods and instance variables should be added to the class itself.
 *  Class methods should be added to the metaclass.
 */
@available(iOS 2.0, *)
public func objc_allocateClassPair(_ superclass: AnyClass?, _ name: UnsafePointer<CChar>, _ extraBytes: Int) -> AnyClass?

/**
 * Registers a class that was allocated using \c objc_allocateClassPair.
 *
 * @param cls The class you want to register.
 */
@available(iOS 2.0, *)
public func objc_registerClassPair(_ cls: AnyClass)

/**
 * Used by Foundation's Key-Value Observing.
 *
 * @warning Do not call this function yourself.
 */
@available(iOS 2.0, *)
public func objc_duplicateClass(_ original: AnyClass, _ name: UnsafePointer<CChar>, _ extraBytes: Int) -> AnyClass

/**
 * Destroy a class and its associated metaclass.
 *
 * @param cls The class to be destroyed. It must have been allocated with
 *  \c objc_allocateClassPair
 *
 * @warning Do not call if instances of this class or a subclass exist.
 */
@available(iOS 2.0, *)
public func objc_disposeClassPair(_ cls: AnyClass)

/* Working with Methods */

/**
 * Returns the name of a method.
 *
 * @param m The method to inspect.
 *
 * @return A pointer of type SEL.
 *
 * @note To get the method name as a C string, call \c sel_getName(method_getName(method)).
 */
@available(iOS 2.0, *)
public func method_getName(_ m: Method) -> Selector

/**
 * Returns the implementation of a method.
 *
 * @param m The method to inspect.
 *
 * @return A function pointer of type IMP.
 */
@available(iOS 2.0, *)
public func method_getImplementation(_ m: Method) -> IMP

/**
 * Returns a string describing a method's parameter and return types.
 *
 * @param m The method to inspect.
 *
 * @return A C string. The string may be \c NULL.
 */
@available(iOS 2.0, *)
public func method_getTypeEncoding(_ m: Method) -> UnsafePointer<CChar>?

/**
 * Returns the number of arguments accepted by a method.
 *
 * @param m A pointer to a \c Method data structure. Pass the method in question.
 *
 * @return An integer containing the number of arguments accepted by the given method.
 */
@available(iOS 2.0, *)
public func method_getNumberOfArguments(_ m: Method) -> UInt32

/**
 * Returns a string describing a method's return type.
 *
 * @param m The method to inspect.
 *
 * @return A C string describing the return type. You must free the string with \c free().
 */
@available(iOS 2.0, *)
public func method_copyReturnType(_ m: Method) -> UnsafeMutablePointer<CChar>

/**
 * Returns a string describing a single parameter type of a method.
 *
 * @param m The method to inspect.
 * @param index The index of the parameter to inspect.
 *
 * @return A C string describing the type of the parameter at index \e index, or \c NULL
 *  if method has no parameter index \e index. You must free the string with \c free().
 */
@available(iOS 2.0, *)
public func method_copyArgumentType(_ m: Method, _ index: UInt32) -> UnsafeMutablePointer<CChar>?

/**
 * Returns by reference a string describing a method's return type.
 *
 * @param m The method you want to inquire about.
 * @param dst The reference string to store the description.
 * @param dst_len The maximum number of characters that can be stored in \e dst.
 *
 * @note The method's return type string is copied to \e dst.
 *  \e dst is filled as if \c strncpy(dst, parameter_type, dst_len) were called.
 */
@available(iOS 2.0, *)
public func method_getReturnType(_ m: Method, _ dst: UnsafeMutablePointer<CChar>, _ dst_len: Int)

/**
 * Returns by reference a string describing a single parameter type of a method.
 *
 * @param m The method you want to inquire about.
 * @param index The index of the parameter you want to inquire about.
 * @param dst The reference string to store the description.
 * @param dst_len The maximum number of characters that can be stored in \e dst.
 *
 * @note The parameter type string is copied to \e dst. \e dst is filled as if \c strncpy(dst, parameter_type, dst_len)
 *  were called. If the method contains no parameter with that index, \e dst is filled as
 *  if \c strncpy(dst, "", dst_len) were called.
 */
@available(iOS 2.0, *)
public func method_getArgumentType(_ m: Method, _ index: UInt32, _ dst: UnsafeMutablePointer<CChar>?, _ dst_len: Int)

@available(iOS 2.0, *)
public func method_getDescription(_ m: Method) -> UnsafeMutablePointer<objc_method_description>

/**
 * Sets the implementation of a method.
 *
 * @param m The method for which to set an implementation.
 * @param imp The implemention to set to this method.
 *
 * @return The previous implementation of the method.
 */
@available(iOS 2.0, *)
public func method_setImplementation(_ m: Method, _ imp: IMP) -> IMP

/**
 * Exchanges the implementations of two methods.
 *
 * @param m1 Method to exchange with second method.
 * @param m2 Method to exchange with first method.
 *
 * @note This is an atomic version of the following:
 *  \code
 *  IMP imp1 = method_getImplementation(m1);
 *  IMP imp2 = method_getImplementation(m2);
 *  method_setImplementation(m1, imp2);
 *  method_setImplementation(m2, imp1);
 *  \endcode
 */
@available(iOS 2.0, *)
public func method_exchangeImplementations(_ m1: Method, _ m2: Method)

/* Working with Instance Variables */

/**
 * Returns the name of an instance variable.
 *
 * @param v The instance variable you want to enquire about.
 *
 * @return A C string containing the instance variable's name.
 */
@available(iOS 2.0, *)
public func ivar_getName(_ v: Ivar) -> UnsafePointer<CChar>?

/**
 * Returns the type string of an instance variable.
 *
 * @param v The instance variable you want to enquire about.
 *
 * @return A C string containing the instance variable's type encoding.
 *
 * @note For possible values, see Objective-C Runtime Programming Guide > Type Encodings.
 */
@available(iOS 2.0, *)
public func ivar_getTypeEncoding(_ v: Ivar) -> UnsafePointer<CChar>?

/**
 * Returns the offset of an instance variable.
 *
 * @param v The instance variable you want to enquire about.
 *
 * @return The offset of \e v.
 *
 * @note For instance variables of type \c id or other object types, call \c object_getIvar
 *  and \c object_setIvar instead of using this offset to access the instance variable data directly.
 */
@available(iOS 2.0, *)
public func ivar_getOffset(_ v: Ivar) -> Int

/* Working with Properties */

/**
 * Returns the name of a property.
 *
 * @param property The property you want to inquire about.
 *
 * @return A C string containing the property's name.
 */
@available(iOS 2.0, *)
public func property_getName(_ property: objc_property_t) -> UnsafePointer<CChar>

/**
 * Returns the attribute string of a property.
 *
 * @param property A property.
 *
 * @return A C string containing the property's attributes.
 *
 * @note The format of the attribute string is described in Declared Properties in Objective-C Runtime Programming Guide.
 */
@available(iOS 2.0, *)
public func property_getAttributes(_ property: objc_property_t) -> UnsafePointer<CChar>?

/**
 * Returns an array of property attributes for a property.
 *
 * @param property The property whose attributes you want copied.
 * @param outCount The number of attributes returned in the array.
 *
 * @return An array of property attributes; must be free'd() by the caller.
 */
@available(iOS 4.3, *)
public func property_copyAttributeList(_ property: objc_property_t, _ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_property_attribute_t>?

/**
 * Returns the value of a property attribute given the attribute name.
 *
 * @param property The property whose attribute value you are interested in.
 * @param attributeName C string representing the attribute name.
 *
 * @return The value string of the attribute \e attributeName if it exists in
 *  \e property, \c nil otherwise.
 */
@available(iOS 4.3, *)
public func property_copyAttributeValue(_ property: objc_property_t, _ attributeName: UnsafePointer<CChar>) -> UnsafeMutablePointer<CChar>?

/* Working with Protocols */

/**
 * Returns a specified protocol.
 *
 * @param name The name of a protocol.
 *
 * @return The protocol named \e name, or \c NULL if no protocol named \e name could be found.
 *
 * @note This function acquires the runtime lock.
 */
@available(iOS 2.0, *)
public func objc_getProtocol(_ name: UnsafePointer<CChar>) -> Protocol?

/**
 * Returns an array of all the protocols known to the runtime.
 *
 * @param outCount Upon return, contains the number of protocols in the returned array.
 *
 * @return A C array of all the protocols known to the runtime. The array contains \c *outCount
 *  pointers followed by a \c NULL terminator. You must free the list with \c free().
 *
 * @note This function acquires the runtime lock.
 */
@available(iOS 2.0, *)
public func objc_copyProtocolList(_ outCount: UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<Protocol>?

/**
 * Returns a Boolean value that indicates whether one protocol conforms to another protocol.
 *
 * @param proto A protocol.
 * @param other A protocol.
 *
 * @return \c YES if \e proto conforms to \e other, otherwise \c NO.
 *
 * @note One protocol can incorporate other protocols using the same syntax
 *  that classes use to adopt a protocol:
 *  \code
 *  @protocol ProtocolName < protocol list >
 *  \endcode
 *  All the protocols listed between angle brackets are considered part of the ProtocolName protocol.
 */
@available(iOS 2.0, *)
public func protocol_conformsToProtocol(_ proto: Protocol?, _ other: Protocol?) -> Bool

/**
 * Returns a Boolean value that indicates whether two protocols are equal.
 *
 * @param proto A protocol.
 * @param other A protocol.
 *
 * @return \c YES if \e proto is the same as \e other, otherwise \c NO.
 */
@available(iOS 2.0, *)
public func protocol_isEqual(_ proto: Protocol?, _ other: Protocol?) -> Bool

/**
 * Returns the name of a protocol.
 *
 * @param proto A protocol.
 *
 * @return The name of the protocol \e p as a C string.
 */
@available(iOS 2.0, *)
public func protocol_getName(_ proto: Protocol) -> UnsafePointer<CChar>

/**
 * Returns a method description structure for a specified method of a given protocol.
 *
 * @param proto A protocol.
 * @param aSel A selector.
 * @param isRequiredMethod A Boolean value that indicates whether aSel is a required method.
 * @param isInstanceMethod A Boolean value that indicates whether aSel is an instance method.
 *
 * @return An \c objc_method_description structure that describes the method specified by \e aSel,
 *  \e isRequiredMethod, and \e isInstanceMethod for the protocol \e p.
 *  If the protocol does not contain the specified method, returns an \c objc_method_description structure
 *  with the value \c {NULL, \c NULL}.
 *
 * @note This function recursively searches any protocols that this protocol conforms to.
 */
@available(iOS 2.0, *)
public func protocol_getMethodDescription(_ proto: Protocol, _ aSel: Selector, _ isRequiredMethod: Bool, _ isInstanceMethod: Bool) -> objc_method_description

/**
 * Returns an array of method descriptions of methods meeting a given specification for a given protocol.
 *
 * @param proto A protocol.
 * @param isRequiredMethod A Boolean value that indicates whether returned methods should
 *  be required methods (pass YES to specify required methods).
 * @param isInstanceMethod A Boolean value that indicates whether returned methods should
 *  be instance methods (pass YES to specify instance methods).
 * @param outCount Upon return, contains the number of method description structures in the returned array.
 *
 * @return A C array of \c objc_method_description structures containing the names and types of \e p's methods
 *  specified by \e isRequiredMethod and \e isInstanceMethod. The array contains \c *outCount pointers followed
 *  by a \c NULL terminator. You must free the list with \c free().
 *  If the protocol declares no methods that meet the specification, \c NULL is returned and \c *outCount is 0.
 *
 * @note Methods in other protocols adopted by this protocol are not included.
 */
@available(iOS 2.0, *)
public func protocol_copyMethodDescriptionList(_ proto: Protocol, _ isRequiredMethod: Bool, _ isInstanceMethod: Bool, _ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_method_description>?

/**
 * Returns the specified property of a given protocol.
 *
 * @param proto A protocol.
 * @param name The name of a property.
 * @param isRequiredProperty \c YES searches for a required property, \c NO searches for an optional property.
 * @param isInstanceProperty \c YES searches for an instance property, \c NO searches for a class property.
 *
 * @return The property specified by \e name, \e isRequiredProperty, and \e isInstanceProperty for \e proto,
 *  or \c NULL if none of \e proto's properties meets the specification.
 */
@available(iOS 2.0, *)
public func protocol_getProperty(_ proto: Protocol, _ name: UnsafePointer<CChar>, _ isRequiredProperty: Bool, _ isInstanceProperty: Bool) -> objc_property_t?

/**
 * Returns an array of the required instance properties declared by a protocol.
 *
 * @note Identical to
 * \code
 * protocol_copyPropertyList2(proto, outCount, YES, YES);
 * \endcode
 */
@available(iOS 2.0, *)
public func protocol_copyPropertyList(_ proto: Protocol, _ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_property_t>?

/**
 * Returns an array of properties declared by a protocol.
 *
 * @param proto A protocol.
 * @param outCount Upon return, contains the number of elements in the returned array.
 * @param isRequiredProperty \c YES returns required properties, \c NO returns optional properties.
 * @param isInstanceProperty \c YES returns instance properties, \c NO returns class properties.
 *
 * @return A C array of pointers of type \c objc_property_t describing the properties declared by \e proto.
 *  Any properties declared by other protocols adopted by this protocol are not included. The array contains
 *  \c *outCount pointers followed by a \c NULL terminator. You must free the array with \c free().
 *  If the protocol declares no matching properties, \c NULL is returned and \c *outCount is \c 0.
 */
@available(iOS 10.0, *)
public func protocol_copyPropertyList2(_ proto: Protocol, _ outCount: UnsafeMutablePointer<UInt32>?, _ isRequiredProperty: Bool, _ isInstanceProperty: Bool) -> UnsafeMutablePointer<objc_property_t>?

/**
 * Returns an array of the protocols adopted by a protocol.
 *
 * @param proto A protocol.
 * @param outCount Upon return, contains the number of elements in the returned array.
 *
 * @return A C array of protocols adopted by \e proto. The array contains \e *outCount pointers
 *  followed by a \c NULL terminator. You must free the array with \c free().
 *  If the protocol adopts no other protocols, \c NULL is returned and \c *outCount is \c 0.
 */
@available(iOS 2.0, *)
public func protocol_copyProtocolList(_ proto: Protocol, _ outCount: UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<Protocol>?

/**
 * Creates a new protocol instance that cannot be used until registered with
 * \c objc_registerProtocol()
 *
 * @param name The name of the protocol to create.
 *
 * @return The Protocol instance on success, \c nil if a protocol
 *  with the same name already exists.
 * @note There is no dispose method for this.
 */
@available(iOS 4.3, *)
public func objc_allocateProtocol(_ name: UnsafePointer<CChar>) -> Protocol?

/**
 * Registers a newly constructed protocol with the runtime. The protocol
 * will be ready for use and is immutable after this.
 *
 * @param proto The protocol you want to register.
 */
@available(iOS 4.3, *)
public func objc_registerProtocol(_ proto: Protocol)

/**
 * Adds a method to a protocol. The protocol must be under construction.
 *
 * @param proto The protocol to add a method to.
 * @param name The name of the method to add.
 * @param types A C string that represents the method signature.
 * @param isRequiredMethod YES if the method is not an optional method.
 * @param isInstanceMethod YES if the method is an instance method.
 */
@available(iOS 4.3, *)
public func protocol_addMethodDescription(_ proto: Protocol, _ name: Selector, _ types: UnsafePointer<CChar>?, _ isRequiredMethod: Bool, _ isInstanceMethod: Bool)

/**
 * Adds an incorporated protocol to another protocol. The protocol being
 * added to must still be under construction, while the additional protocol
 * must be already constructed.
 *
 * @param proto The protocol you want to add to, it must be under construction.
 * @param addition The protocol you want to incorporate into \e proto, it must be registered.
 */
@available(iOS 4.3, *)
public func protocol_addProtocol(_ proto: Protocol, _ addition: Protocol)

/**
 * Adds a property to a protocol. The protocol must be under construction.
 *
 * @param proto The protocol to add a property to.
 * @param name The name of the property.
 * @param attributes An array of property attributes.
 * @param attributeCount The number of attributes in \e attributes.
 * @param isRequiredProperty YES if the property (accessor methods) is not optional.
 * @param isInstanceProperty YES if the property (accessor methods) are instance methods.
 *  This is the only case allowed fo a property, as a result, setting this to NO will
 *  not add the property to the protocol at all.
 */
@available(iOS 4.3, *)
public func protocol_addProperty(_ proto: Protocol, _ name: UnsafePointer<CChar>, _ attributes: UnsafePointer<objc_property_attribute_t>?, _ attributeCount: UInt32, _ isRequiredProperty: Bool, _ isInstanceProperty: Bool)

/* Working with Libraries */

/**
 * Returns the names of all the loaded Objective-C frameworks and dynamic
 * libraries.
 *
 * @param outCount The number of names returned.
 *
 * @return An array of C strings of names. Must be free()'d by caller.
 */
@available(iOS 2.0, *)
public func objc_copyImageNames(_ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<UnsafePointer<CChar>>

/**
 * Returns the dynamic library name a class originated from.
 *
 * @param cls The class you are inquiring about.
 *
 * @return The name of the library containing this class.
 */
@available(iOS 2.0, *)
public func class_getImageName(_ cls: AnyClass?) -> UnsafePointer<CChar>?

/**
 * Returns the names of all the classes within a library.
 *
 * @param image The library or framework you are inquiring about.
 * @param outCount The number of class names returned.
 *
 * @return An array of C strings representing the class names.
 */
@available(iOS 2.0, *)
public func objc_copyClassNamesForImage(_ image: UnsafePointer<CChar>, _ outCount: UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<UnsafePointer<CChar>>?

/* Working with Selectors */

/**
 * Returns the name of the method specified by a given selector.
 *
 * @param sel A pointer of type \c SEL. Pass the selector whose name you wish to determine.
 *
 * @return A C string indicating the name of the selector.
 */
@available(iOS 2.0, *)
public func sel_getName(_ sel: Selector) -> UnsafePointer<CChar>

/**
 * Registers a method with the Objective-C runtime system, maps the method
 * name to a selector, and returns the selector value.
 *
 * @param str A pointer to a C string. Pass the name of the method you wish to register.
 *
 * @return A pointer of type SEL specifying the selector for the named method.
 *
 * @note You must register a method name with the Objective-C runtime system to obtain the
 *  method’s selector before you can add the method to a class definition. If the method name
 *  has already been registered, this function simply returns the selector.
 */
@available(iOS 2.0, *)
public func sel_registerName(_ str: UnsafePointer<CChar>) -> Selector

/**
 * Returns a Boolean value that indicates whether two selectors are equal.
 *
 * @param lhs The selector to compare with rhs.
 * @param rhs The selector to compare with lhs.
 *
 * @return \c YES if \e lhs and \e rhs are equal, otherwise \c NO.
 *
 * @note sel_isEqual is equivalent to ==.
 */
@available(iOS 2.0, *)
public func sel_isEqual(_ lhs: Selector, _ rhs: Selector) -> Bool

/* Objective-C Language Features */

/**
 * This function is inserted by the compiler when a mutation
 * is detected during a foreach iteration. It gets called
 * when a mutation occurs, and the enumerationMutationHandler
 * is enacted if it is set up. A fatal error occurs if a handler is not set up.
 *
 * @param obj The object being mutated.
 *
 */
@available(iOS 2.0, *)
public func objc_enumerationMutation(_ obj: Any)

/**
 * Sets the current mutation handler.
 *
 * @param handler Function pointer to the new mutation handler.
 */
@available(iOS 2.0, *)
public func objc_setEnumerationMutationHandler(_ handler: (@convention(c) (Any) -> Void)?)

/**
 * Set the function to be called by objc_msgForward.
 *
 * @param fwd Function to be jumped to by objc_msgForward.
 * @param fwd_stret Function to be jumped to by objc_msgForward_stret.
 *
 * @see message.h::_objc_msgForward
 */
@available(iOS 2.0, *)
public func objc_setForwardHandler(_ fwd: UnsafeMutableRawPointer, _ fwd_stret: UnsafeMutableRawPointer)

/**
 * Creates a pointer to a function that will call the block
 * when the method is called.
 *
 * @param block The block that implements this method. Its signature should
 *  be: method_return_type ^(id self, method_args...).
 *  The selector is not available as a parameter to this block.
 *  The block is copied with \c Block_copy().
 *
 * @return The IMP that calls this block. Must be disposed of with
 *  \c imp_removeBlock.
 */
@available(iOS 4.3, *)
public func imp_implementationWithBlock(_ block: Any) -> IMP

/**
 * Return the block associated with an IMP that was created using
 * \c imp_implementationWithBlock.
 *
 * @param anImp The IMP that calls this block.
 *
 * @return The block called by \e anImp.
 */
@available(iOS 4.3, *)
public func imp_getBlock(_ anImp: IMP) -> Any?

/**
 * Disassociates a block from an IMP that was created using
 * \c imp_implementationWithBlock and releases the copy of the
 * block that was created.
 *
 * @param anImp An IMP that was created using \c imp_implementationWithBlock.
 *
 * @return YES if the block was released successfully, NO otherwise.
 *  (For example, the block might not have been used to create an IMP previously).
 */
@available(iOS 4.3, *)
public func imp_removeBlock(_ anImp: IMP) -> Bool

/**
 * This loads the object referenced by a weak pointer and returns it, after
 * retaining and autoreleasing the object to ensure that it stays alive
 * long enough for the caller to use it. This function would be used
 * anywhere a __weak variable is used in an expression.
 *
 * @param location The weak pointer address
 *
 * @return The object pointed to by \e location, or \c nil if \e *location is \c nil.
 */
@available(iOS 5.0, *)
public func objc_loadWeak(_ location: AutoreleasingUnsafeMutablePointer<AnyObject?>) -> Any?

/**
 * This function stores a new value into a __weak variable. It would
 * be used anywhere a __weak variable is the target of an assignment.
 *
 * @param location The address of the weak pointer itself
 * @param obj The new object this weak ptr should now point to
 *
 * @return The value stored into \e location, i.e. \e obj
 */
@available(iOS 5.0, *)
public func objc_storeWeak(_ location: AutoreleasingUnsafeMutablePointer<AnyObject?>, _ obj: Any?) -> Any?

/* Associative References */

/**
 * Policies related to associative references.
 * These are options to objc_setAssociatedObject()
 */
public enum objc_AssociationPolicy : UInt {

    
    /**< Specifies a weak reference to the associated object. */
    case OBJC_ASSOCIATION_ASSIGN = 0

    /**< Specifies a strong reference to the associated object.
     *   The association is not made atomically. */
    case OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1

    
    /**< Specifies that the associated object is copied.
     *   The association is not made atomically. */
    case OBJC_ASSOCIATION_COPY_NONATOMIC = 3

    
    /**< Specifies a strong reference to the associated object.
     *   The association is made atomically. */
    case OBJC_ASSOCIATION_RETAIN = 769

    
    /**< Specifies that the associated object is copied.
     *   The association is made atomically. */
    case OBJC_ASSOCIATION_COPY = 771
}

/**
 * Sets an associated value for a given object using a given key and association policy.
 *
 * @param object The source object for the association.
 * @param key The key for the association.
 * @param value The value to associate with the key key for object. Pass nil to clear an existing association.
 * @param policy The policy for the association. For possible values, see “Associative Object Behaviors.”
 *
 * @see objc_setAssociatedObject
 * @see objc_removeAssociatedObjects
 */
@available(iOS 3.1, *)
public func objc_setAssociatedObject(_ object: Any, _ key: UnsafeRawPointer, _ value: Any?, _ policy: objc_AssociationPolicy)

/**
 * Returns the value associated with a given object for a given key.
 *
 * @param object The source object for the association.
 * @param key The key for the association.
 *
 * @return The value associated with the key \e key for \e object.
 *
 * @see objc_setAssociatedObject
 */
@available(iOS 3.1, *)
public func objc_getAssociatedObject(_ object: Any, _ key: UnsafeRawPointer) -> Any?

/**
 * Removes all associations for a given object.
 *
 * @param object An object that maintains associated objects.
 *
 * @note The main purpose of this function is to make it easy to return an object
 *  to a "pristine state”. You should not use this function for general removal of
 *  associations from objects, since it also removes associations that other clients
 *  may have added to the object. Typically you should use \c objc_setAssociatedObject
 *  with a nil value to clear an association.
 *
 * @see objc_setAssociatedObject
 * @see objc_getAssociatedObject
 */
@available(iOS 3.1, *)
public func objc_removeAssociatedObjects(_ object: Any)

/* Hooks for Swift */

/**
 * Function type for a hook that intercepts class_getImageName().
 *
 * @param cls The class whose image name is being looked up.
 * @param outImageName On return, the result of the image name lookup.
 * @return YES if an image name for this class was found, NO otherwise.
 *
 * @see class_getImageName
 * @see objc_setHook_getImageName
 */
public typealias objc_hook_getImageName = @convention(c) (AnyClass, UnsafeMutablePointer<UnsafePointer<CChar>?>) -> ObjCBool

/**
 * Install a hook for class_getImageName().
 *
 * @param newValue The hook function to install.
 * @param outOldValue The address of a function pointer variable. On return,
 *  the old hook function is stored in the variable.
 *
 * @note The store to *outOldValue is thread-safe: the variable will be
 *  updated before class_getImageName() calls your new hook to read it,
 *  even if your new hook is called from another thread before this
 *  setter completes.
 * @note The first hook in the chain is the native implementation of
 *  class_getImageName(). Your hook should call the previous hook for
 *  classes that you do not recognize.
 *
 * @see class_getImageName
 * @see objc_hook_getImageName
 */
@available(iOS 12.0, *)
public func objc_setHook_getImageName(_ newValue: objc_hook_getImageName, _ outOldValue: UnsafeMutablePointer<objc_hook_getImageName?>)

/**
 * Function type for a hook that assists objc_getClass() and related functions.
 *
 * @param name The class name to look up.
 * @param outClass On return, the result of the class lookup.
 * @return YES if a class with this name was found, NO otherwise.
 *
 * @see objc_getClass
 * @see objc_setHook_getClass
 */
public typealias objc_hook_getClass = @convention(c) (UnsafePointer<CChar>, AutoreleasingUnsafeMutablePointer<AnyClass?>) -> ObjCBool

/**
 * Install a hook for objc_getClass() and related functions.
 *
 * @param newValue The hook function to install.
 * @param outOldValue The address of a function pointer variable. On return,
 *  the old hook function is stored in the variable.
 *
 * @note The store to *outOldValue is thread-safe: the variable will be
 *  updated before objc_getClass() calls your new hook to read it,
 *  even if your new hook is called from another thread before this
 *  setter completes.
 * @note Your hook should call the previous hook for class names
 *  that you do not recognize.
 *
 * @see objc_getClass
 * @see objc_hook_getClass
 */

public var OBJC_GETCLASSHOOK_DEFINED: Int32 { get }
@available(iOS 12.2, *)
public func objc_setHook_getClass(_ newValue: objc_hook_getClass, _ outOldValue: UnsafeMutablePointer<objc_hook_getClass?>)

/**
 * Function type for a function that is called when an image is loaded.
 *
 * @param header The newly loaded header.
 */

public typealias objc_func_loadImage = @convention(c) (OpaquePointer) -> Void

/**
 * Add a function to be called when a new image is loaded. The function is
 * called after ObjC has scanned and fixed up the image. It is called
 * BEFORE +load methods are invoked.
 *
 * When adding a new function, that function is immediately called with all
 * images that are currently loaded. It is then called as needed for images
 * that are loaded afterwards.
 *
 * Note: the function is called with ObjC's internal runtime lock held.
 * Be VERY careful with what the function does to avoid deadlocks or
 * poor performance.
 *
 * @param func The function to add.
 */
public var OBJC_ADDLOADIMAGEFUNC_DEFINED: Int32 { get }
@available(iOS 13.0, *)
public func objc_addLoadImageFunc(_ func: objc_func_loadImage)

/**
 * Function type for a hook that provides a name for lazily named classes.
 *
 * @param cls The class to generate a name for.
 * @return The name of the class, or NULL if the name isn't known or can't me generated.
 *
 * @see objc_setHook_lazyClassNamer
 */
public typealias objc_hook_lazyClassNamer = @convention(c) (AnyClass) -> UnsafePointer<CChar>?

/**
 * Install a hook to provide a name for lazily-named classes.
 *
 * @param newValue The hook function to install.
 * @param outOldValue The address of a function pointer variable. On return,
 *  the old hook function is stored in the variable.
 *
 * @note The store to *outOldValue is thread-safe: the variable will be
 *  updated before objc_getClass() calls your new hook to read it,
 *  even if your new hook is called from another thread before this
 *  setter completes.
 * @note Your hook must call the previous hook for class names
 *  that you do not recognize.
 */

public var OBJC_SETHOOK_LAZYCLASSNAMER_DEFINED: Int32 { get }
@available(iOS 14.0, *)
public func objc_setHook_lazyClassNamer(_ newValue: objc_hook_lazyClassNamer, _ oldOutValue: UnsafeMutablePointer<objc_hook_lazyClassNamer>)

/**
 * Callback from Objective-C to Swift to perform Swift class initialization.
 */

public typealias _objc_swiftMetadataInitializer = @convention(c) (AnyClass, UnsafeMutableRawPointer?) -> AnyClass?

/**
 * Perform Objective-C initialization of a Swift class.
 * Do not call this function. It is provided for the Swift runtime's use only
 * and will change without notice or mercy.
 */

public var OBJC_REALIZECLASSFROMSWIFT_DEFINED: Int32 { get }
@available(iOS 12.2, *)
public func _objc_realizeClassFromSwift(_ cls: AnyClass?, _ previously: UnsafeMutableRawPointer?) -> AnyClass?

/* Obsolete types */

// class is not a metaclass

// class is a metaclass

// class's +initialize method has completed

// class is posing

// unused

// class and subclasses need cache flush during image loading

// method cache should grow when full

// unused

// methodLists is array of method lists

// the JavaBridge constructs classes with these markers

// thread-safe +initialize

// bundle unloading

// C++ ivar support

// Lazy method list arrays

// +load implementation

// objc_allocateClassPair API

// class compiled with bigger class structure

/* variable length structure */

/* variable length structure */

/* variable size */

/* total = mask + 1 */

/* Obsolete functions */

public var OBSOLETE_OBJC_GETCLASSES: Int32 { get }

// This function was accidentally deleted in 10.9.

public var OBJC_NEXT_METHOD_LIST: Int32 { get }

