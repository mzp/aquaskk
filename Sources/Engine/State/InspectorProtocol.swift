//
//  InspectorProtocol.swift
//  AquaSKK
//
//  Created by mzp on 2025/03/08.
//

protocol InspectorProtocol {
    func inspect(handler: any HandlerProtocol, event: GenericEvent)
}
