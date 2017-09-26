//
//  Input.swift
//  DeltaCore
//
//  Created by Riley Testut on 7/4/15.
//  Copyright © 2015 Riley Testut. All rights reserved.
//

public enum InputType: Codable
{
    case controller(GameControllerInputType)
    case game(GameType)
}

extension InputType: RawRepresentable
{
    public var rawValue: String {
        switch self
        {
        case .controller(let inputType): return inputType.rawValue
        case .game(let gameType): return gameType.rawValue
        }
    }
    
    public init(rawValue: String)
    {
        let gameType = GameType(rawValue)
        
        if Delta.core(for: gameType) != nil
        {
            self = .game(gameType)
        }
        else
        {
            let inputType = GameControllerInputType(rawValue)
            self = .controller(inputType)
        }
    }
}

extension InputType: Hashable
{
    public var hashValue: Int {
        return self.rawValue.hashValue
    }
}

// Conformance to CodingKey allows compiler to automatically generate intValue/stringValue logic for enums.
public protocol Input: CodingKey
{
    var type: InputType { get }
}

public extension Input
{
    init?(input: Input)
    {
        self.init(stringValue: input.stringValue)
        
        guard self.type == input.type else { return nil }
    }
}

public func ==(lhs: Input, rhs: Input) -> Bool
{
    return lhs.type == rhs.type && lhs.stringValue == rhs.stringValue
}

public func !=(lhs: Input, rhs: Input) -> Bool
{
    return !(lhs == rhs)
}

public func ~=(pattern: Input, value: Input) -> Bool
{
    return pattern == value
}
