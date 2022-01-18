//
//  SliderViewModel.swift
//  CombineUIKit
//
//  Created by Alexander Ryakhin on 1/18/22.
//

import Combine

final class SliderViewModel: ObservableObject {
    let currentSliderValue = CurrentValueSubject<Double, Never>(0)
}
