//
//  FiltersMainView.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 10.08.2023.
//

import Foundation
import SnapKit

final class FiltersMainView: BaseInteractiveView, UIPickerViewDelegate {

    // MARK: - Private Properties

    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()

        return picker
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Category","Country", "Source"])
        segment.selectedSegmentIndex = 0
        return segment
    }()

    // MARK: - Lifecycle

    override func addViews() {
        addSubview(segmentControl)
        addSubview(pickerView)
    }

    override func anchorViews() {
        pickerView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        
        segmentControl.snp.makeConstraints {
            $0.bottom.equalTo(pickerView.snp.top).offset(-10)
            $0.centerX.equalTo(pickerView)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
}
