//
//  Helpers.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import Foundation
import UIKit

let deviceID = UIDevice.current.identifierForVendor!.uuidString

var deviceWidth: CGFloat {
    return UIScreen.main.bounds.width
}

var deviceHeight: CGFloat {
    return UIScreen.main.bounds.height
}

var isLowScreenHeight: Bool {
    return UIScreen.main.bounds.height < 568
}

var isLowScreenWidth: Bool {
    return UIScreen.main.bounds.width <= 320
}

var isIphoneSix: Bool {
    return UIScreen.main.bounds.height == 667
}

var isMediumScreenHeight: Bool {
    return UIScreen.main.bounds.height <= 667
}

var isIphoneSixPlus: Bool {
    return UIScreen.main.bounds.width == 414
}

enum InternetConnectionStatus {
    case unknown
    case notReachable
    case reachableViaWiFi
    case reachableViaCellular
}

enum NAError: Error {
    case connectionError
    case incorrectData
    case cancel
    case removeFile
    case syncError
    case permissionDenied
    case unknown
    case transactionValidation
    case noResponse
    case unauthorized
}

var connectionStatus: InternetConnectionStatus {
    return .unknown
}

var bottomSafeAreaInset: CGFloat {
    if #available(iOS 11.0, *) {
        if let bottomEdge = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            return bottomEdge
        }
    }
    return 0.0
}

var topSafeAreaInset: CGFloat {
    if #available(iOS 11.0, *) {
        if let topEdge = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            return topEdge
        }
    }
    return 0.0
}

private enum CountTextType: Int {
    case one, two, many
}

private func countTextTypeWithCount(_ count: Int) -> CountTextType {
    var countLastSymbol: String = "\(count)"
    let countString = NSString(string: countLastSymbol)
    if countString.length > 1 {
        let prevSymbol = countString.substring(with: NSRange(location: countString.length - 2, length: 1))
        let lastSymbol = countString.substring(with: NSRange(location: countString.length - 1, length: 1))
        if prevSymbol == "1" {
            return .many
        }
        countLastSymbol = lastSymbol
    }
    if countLastSymbol == "1" {
        return .one
    } else if countLastSymbol == "2" || countLastSymbol == "3" || countLastSymbol == "4" {
        return .two
    }
    return .many
}

func createDateFromComponents(year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, timezone: String? = nil) -> Date? {
    var gregorianCalendar = Calendar(identifier: .gregorian)
    if let timezone = timezone {
        gregorianCalendar.timeZone = TimeZone(abbreviation: timezone) ?? TimeZone.current
    } else {
        gregorianCalendar.timeZone = TimeZone.current
    }
    var components = DateComponents()
    components.setValue(year, for: .year)
    components.setValue(month, for: .month)
    components.setValue(day, for: .day)
    components.setValue(hour, for: .hour)
    components.setValue(minute, for: .minute)
    components.setValue(0, for: .second)
    return gregorianCalendar.date(from: components)
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(
            for: locationOfTouchInTextContainer,
            in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension Range where Bound == String.Index {
    var nsRange: NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset - self.lowerBound.encodedOffset)
    }
}

extension Int {
    
    public static var random: Int {
        return Int.random(num: Int.max)
    }
    
    public static func random(num: Int) -> Int {
        return Int(arc4random_uniform(UInt32(num)))
    }
    
    public static func random(min: Int, max: Int) -> Int {
        return Int.random(num: max - min + 1) + min
    }
    
    func hourWithTimezone() -> Int {
        let difference = TimeZone.current.secondsFromGMT()
        return self + (difference / 3600)
    }
}

extension Double {
    
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

extension Float {
    func toDistanceFormat() -> String {
        let numberFormatter = NumberFormatter.distanceFormatter
        let formatted = numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(formatted) " + "km"
    }
}

extension Double {
    func toCurrencyFormat() -> String {
        let numberFormatter = NumberFormatter.currencyFormatter
        let formatted = numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return formatted
    }
}

extension Int {
    func toCurrencyFormat() -> String {
        let numberFormatter = NumberFormatter.currencyFormatter
        let formatted = numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return formatted
    }
}

extension UITableView {
    func reloadData(transition type: String,
                    subtype: String? = nil,
                    timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: . easeInEaseOut),
                    duration: TimeInterval = 0.2) {
        let animation = CATransition()
        animation.type = CATransitionType(rawValue: type)
        if let subtype = subtype {
            animation.subtype = CATransitionSubtype(rawValue: subtype)
        }
        animation.timingFunction = timingFunction
        animation.fillMode = CAMediaTimingFillMode.both
        animation.duration = duration
        self.layer.add(animation, forKey: "UITableViewReloadDataAnimationKey")
        self.reloadData()
    }
}

extension UIImage {
    
    class func backgroundImage(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func multiplyImageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        self.draw(in: rect, blendMode: .multiply, alpha: 1)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    static func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func resizeImageToMaxSide(maxSize: CGFloat) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        guard width > maxSize || height > maxSize else { return self }
        let aspect = width / height
        
        var newWidth: CGFloat!
        var newHeight: CGFloat!
        if aspect > 1 {
            newWidth = maxSize
            newHeight = newWidth / aspect
        } else {
            newHeight = maxSize
            newWidth = newHeight * aspect
        }
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    enum GradientDirection: Int {
        case vertical = 0, horizontal
    }
    
    func makeGradientedImage(
        _ size: CGSize,
        endColor: UIColor,
        startColor: UIColor,
        direction: GradientDirection = .vertical) -> UIImage {
            UIGraphicsBeginImageContext(size)
            let context = UIGraphicsGetCurrentContext()
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let locations: [CGFloat] = [0.0, 1.0]
            let colors = [startColor.cgColor, endColor.cgColor] as CFArray
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
            let startPoint = direction == .vertical ? CGPoint(x: size.width * 0.5, y: size.height) :
            CGPoint(x: size.width, y: size.height * 0.5)
            let endPoint = direction == .vertical ? CGPoint(x: size.width * 0.5, y: 0) :
            CGPoint(x: 0, y: size.height * 0.5)
            context!.drawLinearGradient(
                gradient!,
                start: startPoint,
                end: endPoint,
                options: CGGradientDrawingOptions(rawValue: UInt32(0)))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
    
}

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, forState state: UIControl.State) {
        let backgroundImage = UIImage.backgroundImage(withColor: color)
        setBackgroundImage(backgroundImage, for: state)
    }
}

extension Date {
    
    func toBeautifulString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM dd, EE"
        return formatter.string(from: self)
    }
    
    func toShortDayString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EE, MMM dd"
        return formatter.string(from: self)
    }
    
    func toNearestFormat() -> String {
        if self.isToday {
            return "Today"
        } else if self.isTomorrow {
            return "Tomorrow"
        } else {
            return self.toShortDayString()
        }
    }
    
    func toLongString() -> String {
        let date = self.toString()
        let time = self.toTimeString()
        return date + " в " + time
    }
    
    func toLocalDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    func toString(_ format: String, timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        dateFormatter.dateFormat = "MM.dd.yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toShortYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        dateFormatter.dateFormat = "MM.dd.yy"
        return dateFormatter.string(from: self)
    }
    
    static func serverStringToDate(_ string: String) -> Date? {
        // 2019-02-13T19:29:13
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: string)
    }
    
    func toOptimizedTitleString() -> String {
        if self.isToday {
            return "Сегодня в " + self.toTimeString()
        } else if self.isTomorrow {
            return "Завтра в " + self.toTimeString()
        } else if self.isYesterday {
            return "Вчера в " + self.toTimeString()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "E, MMM d"
        return (dateFormatter.string(from: self) + " в " + toTimeString())
    }
    
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func isGreater(thanDate date: Date, minutes: Int = 0) -> Bool {
        return self.timeIntervalSince(date) > Double(60 * minutes)
    }
    
    func getComponent(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    var weekday: String {
        let weekday = getComponent(.weekday)
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[weekday - 1]
    }
    
    var isCurrentYear: Bool {
        return Calendar.current.component(Calendar.Component.year, from: self) ==
        Calendar.current.component(Calendar.Component.year, from: Date())
    }
    
    /// Получаем дату — текущая +/- дни
    public func dateByAddingDays(_ days: Int) -> Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day,
                                             value: days,
                                             to: self,
                                             options: [])!
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self.startOfDay())
        return Calendar.current.date(from: components)!
    }
    
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func endOfMonth() -> Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    var nextDay: Date {
        Calendar.current.date(byAdding: DateComponents(day: 1), to: self)!
    }
    
    var nextMonth: Date {
        let newDate = Calendar.current.date(byAdding: .month, value: 1, to: self)!
        return newDate
    }
    
    var endOfWeek: Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        
        let addWeekdays = 7 - weekday
        var components = DateComponents()
        components.weekday = addWeekdays + 1
        let sunday = calendar.date(byAdding: components, to: self)!
        
        return sunday
    }
    
    var weekends: ClosedRange<Date> {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        
        let addWeekdays = 7 - weekday
        var components = DateComponents()
        components.weekday = addWeekdays
        
        let nextSaturday = calendar.date(byAdding: components, to: self)!
        components.weekday = addWeekdays + 1
        let nextSunday = calendar.date(byAdding: components, to: self)!
        
        return nextSaturday...nextSunday
    }
    
    var nextWeekend: ClosedRange<Date> {
        let nextMonday = self.endOfWeek.nextDay
        return nextMonday.weekends
    }
    
    var nextWeek: ClosedRange<Date> {
        let nextMonday = self.endOfWeek.nextDay
        return nextMonday...nextMonday.endOfWeek
    }
    
    func addTime(_ date: Date) -> Date {
        let hour = date.getComponent(.hour)
        let minute = date.getComponent(.minute)
        return Calendar.current.date(byAdding: DateComponents(hour: hour, minute: minute), to: self)!
    }
}

extension NumberFormatter {
    static let timerFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        formatter.minimumIntegerDigits = 2
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    static let distanceFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.decimalSeparator = "."
        numberFormatter.usesGroupingSeparator = true
        return numberFormatter
    }()
    
    static let currencyFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.groupingSeparator = " "
        numberFormatter.usesGroupingSeparator = true
        return numberFormatter
    }()
}

extension String {
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    func configureEndDate(_ startDate: Date) -> Date? {
        guard let components = self.durationComponents() else { return nil }
        return Calendar.current.date(byAdding: components, to: startDate)
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    func clean() -> String {
        return self
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
    }
    
    static func height(boundingWidth width: CGFloat, text: String, font: UIFont) -> CGFloat {
        return ceil(NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                        options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                        attributes: [.font: font],
                                                        context: nil).size.height)
    }
    
    static func width(boundingHeight height: CGFloat, text: String, font: UIFont) -> CGFloat {
        return ceil(NSString(string: text).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
                                                        options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                        attributes: [.font: font],
                                                        context: nil).size.width)
    }
    
    static func timerString(interval: TimeInterval) -> String {
        let minutes = Int(interval / 60)
        let hours = Int(minutes / 60)
        let extraMinutes = minutes - hours * 60
        let extraSeconds = Int(interval) - minutes * 60
        var result = ""
        if hours > 0 {
            result += (NumberFormatter.timerFormatter.string(from: hours as NSNumber) ?? "") + ":"
        }
        result += (NumberFormatter.timerFormatter.string(from: extraMinutes as NSNumber) ?? "") + ":"
        result += (NumberFormatter.timerFormatter.string(from: extraSeconds as NSNumber) ?? "")
        return result
    }
    
    var first: String {
        return String(prefix(1))
    }
    var last: String {
        return String(suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(dropFirst())
    }
    
    func makeSpaces() -> String {
        guard !self.isEmpty else { return self }
        let tryRegexPattern = try? NSRegularExpression(pattern: "\\d{4}", options: .caseInsensitive)
        guard let regexPattern = tryRegexPattern else { return self }
        let nsString = NSString(string: self)
        let matches = regexPattern.matches(in: self, options: .withoutAnchoringBounds, range: nsString.range(of: self))
        guard !matches.isEmpty else { return self }
        let matchStrings = matches.compactMap { (result) -> String? in
            return nsString.substring(with: result.range)
        }
        let count = matches.count > 4 ? 4 : matches.count
        let components = matchStrings.prefix(count)
        let lastMatchRange = matches[count - 1].range
        let number = components.joined(separator: " ") + nsString.substring(from: lastMatchRange.location + lastMatchRange.length)
        return number
    }
    
//    var localized: String {
//        return localizedWithComment("")
//    }
    
    func localizedWithComment(_ comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
    
    var isEmptyOrWhitespace: Bool {
        return self.trim() == ""
    }
    
    func trim() -> String {
        if self.isEmpty {
            return ""
        }
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    /** Implement attributes to characters surrounded within the delimiter characters & return them. Example: "This is $$bold$$ text". */
    func customize(attributes: [NSAttributedString.Key: Any], delimiter: String) -> NSMutableAttributedString {
        let string = self as NSString
        let attributedString = NSMutableAttributedString(string: string as String)
        attributedString.customize(attributes: attributes, delimiter: delimiter)
        return attributedString
    }
    
    /** Simplification of the 'customize()' method. It only accepts color. */
    func highlight(with color: UIColor, delimiter: String) -> NSMutableAttributedString {
        return self.customize(
            attributes: [NSAttributedString.Key(
                rawValue: NSAttributedString.Key.foregroundColor.rawValue): color],
            delimiter: delimiter)
    }
    func addAttributes(attributes: [NSAttributedString.Key: Any], delimiter: String) -> NSMutableAttributedString {
        return self.customize(attributes: attributes, delimiter: delimiter)
    }
    
    func applyCardMask() -> String {
        if self.count >= 8 {
            let arr = Array(self)
            return "\(arr[0])\(arr[1])\(arr[2])\(arr[3]) **** **** \(arr[count - 4])\(arr[count - 3])\(arr[count - 2])\(arr[count - 1])"
        } else {
            return self
        }
    }
    
    public static func getDescriptionString(value: [String: Any]?, header: String) -> String {
        guard let value = value else { return "" }
        var logString = "\(header): ["
        value.forEach({ (key, value) in
            logString += key + ": \(value), "
        })
        logString.removeLast()
        logString += "]\n"
        return logString
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func isPasswordValid() -> Bool {
        let emailRegex = "^(?=.*[A-Z])(?=.*[0-9])[A-Za-z\\d$@$!%*#?&]{8,128}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}

extension NSMutableAttributedString {
    func highlight(with color: UIColor, delimiter: String) {
        self.customize(
            attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color],
            delimiter: delimiter)
    }
    func addAttributes(attributes: [NSAttributedString.Key: Any], delimiter: String) {
        self.customize(attributes: attributes, delimiter: delimiter)
    }
    func customize(attributes: [NSAttributedString.Key: Any], delimiter: String) {
        let escaped = NSRegularExpression.escapedPattern(for: delimiter)
        if let regex = try? NSRegularExpression(pattern: "\(escaped)(.*?)\(escaped)", options: []) {
            var offset = 0
            regex.enumerateMatches(in: self.string,
                                   options: [],
                                   range: NSRange(location: 0,
                                                  length: self.string.count)) { (result, _, _) -> Void in
                guard let result = result else {
                    return
                }
                
                let range = NSRange(
                    location: result.range.location + offset,
                    length: result.range.length)
                self.addAttributes(attributes, range: range)
                let replacement = regex.replacementString(
                    for: result,
                       in: self.string,
                       offset: offset,
                       template: "$1")
                self.replaceCharacters(in: range, with: replacement)
                offset -= (2 * delimiter.count)
            }
        }
    }
}

extension UIView {
    
    private var gradientlayer: CAGradientLayer? {
        var grLayer: CAGradientLayer?
        if let sublayers = self.layer.sublayers {
            for layer in sublayers {
                if let glayer = layer as? CAGradientLayer {
                    grLayer = glayer
                    break
                }
            }
        }
        return grLayer
    }
    
    func shake() {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = [ NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0)),
                             NSValue(caTransform3D: CATransform3DMakeTranslation(5, 0, 0)) ]
        animation.autoreverses = true
        animation.repeatCount = 2
        animation.duration = 0.07
        self.layer.add(animation, forKey: nil)
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.duration = 0.2
        self.layer.add(transition, forKey: kCATransition)
    }
    
    func setGradient(_ colors: [UIColor], horizontal: Bool = false) {
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
        self.gradientlayer?.removeFromSuperlayer()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map({ (color) -> CGColor in
            return color.cgColor
        })
        gradient.startPoint = horizontal ? CGPoint(x: 0.0, y: 0.5) : CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = horizontal ? CGPoint(x: 1.0, y: 0.5) : CGPoint(x: 0.5, y: 1.0)
        var locations = [NSNumber]()
        for index in 0..<colors.count {
            let doubleValue = Double(index) * 1.0 / Double(colors.count - 1)
            let location = NSNumber(value: Double(round(100 * doubleValue) / 100) as Double)
            locations.append(location)
        }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func updateGradient(rect: CGRect? = nil) {
        gradientlayer?.frame = rect ?? self.bounds
    }
    
    var shadowColor: UIColor {
        get {
            return layer.shadowColor == nil ? UIColor.clear : UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    func addShadow(_ color: UIColor = UIColor.black,
                   offset: CGSize = CGSize(width: 0.0, height: 0.0),
                   radius: CGFloat = 10,
                   opacity: Float = 0.15) {
        shadowColor = color
        shadowOffset = offset
        shadowOpacity = opacity
        shadowRadius = radius
    }
    
    func fadeIn(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
            self.isHidden = true
        })
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(withClass: T.Type) -> T? {
        return instantiateViewController(withIdentifier: withClass.identifier) as? T
    }
}

extension UITableView {
    func register<T: UITableViewCell>(nib: T.Type) {
        self.register(UINib(nibName: String(describing: nib), bundle: nil), forCellReuseIdentifier: String(describing: nib))
    }
    func register<T: UITableViewCell>(class cellClass: T.Type) {
        self.register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(nib: T.Type) {
        self.register(UINib(nibName: String(describing: nib), bundle: nil), forCellWithReuseIdentifier: String(describing: nib))
    }
    func register<T: UICollectionViewCell>(class cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func register<T: UICollectionReusableView>(`class`: T.Type, kind elementKind: String) {
        self.register(`class`, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: `class`.identifier)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}

extension UIWindow {
    var topViewController: UIViewController? {
        return parseVC(vc: self.rootViewController)
    }
    
    private func parseVC(vc: UIViewController?) -> UIViewController? {
        if let presentedVC = vc?.presentedViewController {
            return parseVC(vc: presentedVC)
        } else if let navVC = vc as? UINavigationController {
            return parseVC(vc: navVC.topViewController)
        } else if let tabBarVC = vc as? UITabBarController {
            return parseVC(vc: tabBarVC.selectedViewController)
        } else if let commonVC = vc as? UIViewControllerX {
            return commonVC
        }
        return nil
    }
}

extension URL {
    
    @discardableResult
    func addSkipBackupAttributeToItemAtURL() -> Bool {
        var url = self
        var success: Bool
        
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try url.setResourceValues(resourceValues)
            success = true
        } catch let error as NSError {
            success = false
            print("Error excluding \(url.lastPathComponent) from backup \(error)")
        }
        return success
    }
    
    static func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
}

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

extension Sequence {
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension Sequence where Iterator.Element: Equatable {
    func unique() -> [Iterator.Element] {
        return reduce([], { collection, element in collection.contains(element) ? collection : collection + [element] })
    }
}

extension UISearchBar {
    func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = svs.first(where: { $0 is T }) as? T else { return nil }
        return element
    }
}

extension UIView {
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        else { fatalError("missing expected nib named: \(name)") }
        guard
            let view = nib.first as? Self
        else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
}

extension UITableView {
    
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6,
                           delay: 0.08 * Double(delayCounter),
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}

extension UIView {
    
    func strokeBorder() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.mask = maskLayer
        
        let line = NSNumber(value: Float(self.bounds.width / 2))
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineDashPattern = [line]
        borderLayer.lineDashPhase = self.bounds.width / 4
        borderLayer.lineWidth = 10
        borderLayer.frame = self.bounds
        self.layer.cornerRadius = 5
        self.layer.addSublayer(borderLayer)
    }
}

extension UILabel {
    
    // MARK: - spacingValue is spacing that you need
    func addInterlineSpacing(spacingValue: CGFloat = 2) {
        
        // MARK: - Check if there's any text
        guard let textString = text else { return }
        
        // MARK: - Create "NSMutableAttributedString" with your text
        let attributedString = NSMutableAttributedString(string: textString)
        
        // MARK: - Create instance of "NSMutableParagraphStyle"
        let paragraphStyle = NSMutableParagraphStyle()
        
        // MARK: - Actually adding spacing we need to ParagraphStyle
        paragraphStyle.lineSpacing = spacingValue
        // swiftlint:disable all

        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
                          ))
        
        // MARK: - Assign string that you've modified to current attributed Text
        attributedText = attributedString
    }
    
}

extension String {
    func configureHTML() -> NSAttributedString? {
        let encodedData = self.data(using: String.Encoding.utf8)!
        var attributedString: NSAttributedString?
        do {
            attributedString = try NSAttributedString(
                data: encodedData,
                options: [
                    NSAttributedString.DocumentReadingOptionKey.documentType:
                        NSAttributedString.DocumentType.html,
                    NSAttributedString.DocumentReadingOptionKey.characterEncoding:
                        NSNumber(value: String.Encoding.utf8.rawValue)],
                documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("error")
        }
        return attributedString
    }
    
    func htmlAttributed(using font: UIFont) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
            "html *" +
            "{" +
            "line-height: 1.14;" +
            "font-size: \(font.pointSize)px !important;" +
            "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

extension UIButton {
    func onClick(action: @escaping () -> Void) {
        self.subscribe(to: .touchUpInside, action: action)
    }
    
    func onClick(action: @escaping (UIButton) -> Void) {
        self.subscribe(to: .touchUpInside, typedAction: { control in
            action(control as! UIButton)
        })
    }
}

private class ClosureSleeve<TControll: UIControl> {
    let closure: (TControll) -> Void
    
    init(attachTo: AnyObject, closure: @escaping (TControll) -> Void) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc func invoke(_ sender: Any) {
        guard let sender = sender as? TControll else {
            return
        }
        closure(sender)
    }
}

extension UIControl {
    func subscribe(to controlEvents: UIControl.Event = .primaryActionTriggered,
                   typedAction: @escaping (UIControl) -> Void) {
        let sleeve = ClosureSleeve(attachTo: self, closure: typedAction)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
    
    func subscribe(to controlEvents: UIControl.Event = .primaryActionTriggered,
                   action: @escaping () -> Void) {
        let sleeve = ClosureSleeve(attachTo: self, closure: { _ in action() })
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}

extension String {
    func toDuration() -> String {
        var duration = self
        if duration.hasPrefix("PT") { duration.removeFirst(2) }
        let hour, minute, second: Double
        if let index = duration.firstIndex(of: "H") {
            hour = Double(duration[..<index]) ?? 0
            duration.removeSubrange(...index)
        } else { hour = 0 }
        if let index = duration.firstIndex(of: "M") {
            minute = Double(duration[..<index]) ?? 0
            duration.removeSubrange(...index)
        } else { minute = 0 }
        if let index = duration.firstIndex(of: "S") {
            second = Double(duration[..<index]) ?? 0
        } else { second = 0 }
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US")
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short
        
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: hour * 3600 + minute * 60 + second) ?? self
    }
    
    func toDate(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func fromTimeFormat() -> Date? {
        toDate("HH:mm:ss")
    }
    
    func durationComponents() -> DateComponents? {
        .durationFrom8601String(self)
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    subscript (rangeInt: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, rangeInt.lowerBound)),
                                            upper: min(count, max(0, rangeInt.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension DateComponents {
    // Note: Does not handle decimal values or overflow values
    // Format: PnYnMnDTnHnMnS or PnW
    static func durationFrom8601String(_ durationString: String) -> DateComponents? {
        guard durationString.starts(with: "P") else {
            logErrorMessage(durationString: durationString)
            return nil
        }

        let durationString = String(durationString.dropFirst())
        var dateComponents = DateComponents()

        if durationString.contains("W") {
            let weekValues = componentsForString(durationString, designatorSet: CharacterSet(charactersIn: "W"))

            if let weekValue = weekValues["W"], let weekValueDouble = Double(weekValue) {
                // 7 day week specified in ISO 8601 standard
                dateComponents.day = Int(weekValueDouble * 7.0)
            }
            return dateComponents
        }

        let tRange = (durationString as NSString).range(of: "T", options: .literal)
        let periodString: String
        let timeString: String
        if tRange.location == NSNotFound {
            periodString = durationString
            timeString = ""
        } else {
            periodString = (durationString as NSString).substring(to: tRange.location)
            timeString = (durationString as NSString).substring(from: tRange.location + 1)
        }

        // DnMnYn
        let periodValues = componentsForString(periodString, designatorSet: CharacterSet(charactersIn: "YMD"))
        dateComponents.day = Int(periodValues["D"] ?? "")
        dateComponents.month = Int(periodValues["M"] ?? "")
        dateComponents.year = Int(periodValues["Y"] ?? "")

        // SnMnHn
        let timeValues = componentsForString(timeString, designatorSet: CharacterSet(charactersIn: "HMS"))
        dateComponents.second = Int(timeValues["S"] ?? "")
        dateComponents.minute = Int(timeValues["M"] ?? "")
        dateComponents.hour = Int(timeValues["H"] ?? "")

        return dateComponents
    }

    private static func componentsForString(_ string: String, designatorSet: CharacterSet) -> [String: String] {
        if string.isEmpty {
            return [:]
        }

        let componentValues = string.components(separatedBy: designatorSet).filter { !$0.isEmpty }
        let designatorValues = string.components(separatedBy: .decimalDigits).filter { !$0.isEmpty }

        guard componentValues.count == designatorValues.count else {
            print("String: \(string) has an invalid format")
            return [:]
        }

        return Dictionary(uniqueKeysWithValues: zip(designatorValues, componentValues))
    }

    private static func logErrorMessage(durationString: String) {
        print("String: \(durationString) has an invalid format")
        print("The durationString must have a format of PnYnMnDTnHnMnS or PnW")
    }
}

enum Constants {
    static let leftRightOffset: CGFloat = 16
}
