//
//  ContentView.swift
//  WeSplit
//
//  Created by 买祥 on 2023/1/5.
//

import SwiftUI

struct ContentView: View {
    /// 读取写入焦点状态的属性包装器，和 focused() modifier 一起使用，将 View 的焦点状态和 变量 双向绑定，当被 focused() 修饰的 View 焦点发生变化时，这个属性包装器的状态会同步跟新。手动更新这个属性值时，View 的焦点状态也会随着变更，例如将 amountIsFocused 改为 false 时，对应绑定的 textFiled 将失去焦点。
    @FocusState private var amountIsFocused: Bool
    /// 支付金额
    @State private var checkAmount = 0.0
    /// 人数
    @State private var numberOfPeople = 0
    /// 小费百分比
    @State private var tipPercentage = 20
    /// 列举小费百分比的种类
    private let tipPercentages = [10, 15, 20, 25, 0]
    /// 每个人需要支付的金额
    private var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        // 计算每个人平均费用，并返回
        return self.grandTotal / Double(peopleCount)
    }
    /// 总金额（含小费）
    private var grandTotal: Double {
        let tipSelection = Double(tipPercentage)
        // 计算总金额，支付金额 + 小费金额
        let grandTotal = checkAmount * (1 + tipSelection / 100)
        return grandTotal
    }
    
    // 当 @State 属性发生变更时，SwiftUi 会重新访问 body 计算属性，即重新加载 UI
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Form Section 1 输入金额 & 选择人数
                Section {
                    TextField("Amount",
                              value: $checkAmount,
                              format: .currency(code: Locale.current.currency?.identifier ?? "USD") // Locale.current 读取用户设备中设置的语言环境，即“设置-通用-语言与地区”中的设置（currency?.identifier 表示该语言与地区的货币代码）
                    )
                    .keyboardType(.decimalPad) // keyboardType modifiier 可以设置键盘类型
                    .focused($amountIsFocused) // 与 @FocusState 属性包装器一起使用。通过将焦点状态绑定到给定的布尔状态值来修改此视图。
                    
                    // selection 与当前所选选项的属性的绑定。(这里 selection 的值类似数组 index，例如 2 People 的 selection 值实际是 0 ，因为 ForEach 从 2 开始，2 的 index 是 0）
                    Picker("Numbers of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) People")
                        }
                    }
                    // Text("Numbers of people Selection: \(numberOfPeople)")
                }
                
                // MARK: - Form Section 2 选择小费百分比
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    // Picker 样式（分段）
                    .pickerStyle(.segmented)
                    // Section 可以添加 header 和 footer（多个尾随闭包）
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                // MARK: - Form Section 3 显示平均每人支付金额
                Section {
                    Text(totalPerPerson,
                         format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                } header: {
                    Text("Amount per person")
                }
                
                // MARK: - Form Section 3 显示总金额（含小费）
                Section {
                    Text(grandTotal, format:.currency(code: Locale.current.currency?.identifier ?? "USD"))
                } header: {
                    Text("Total amount")
                }
            }
            // navigationTitle 需要修饰 NavigationStack 内部的 View，原因是 NavigationStack 可能存在多个 View，导航栏标题是与栈内的 View 关联的，而非与 NavigationStack 关联
            .navigationTitle("WeSplit")
            // 工具栏 or 导航栏
            .toolbar {
                // 在键盘上方增加一组工具
                ToolbarItemGroup(placement: .keyboard) {
                    // 这里的 Spacer() 用于将 Button 推到右侧
                    Spacer()
                    // 点击按钮，修改 amountIsFocused 的值为 False，让 TextField 失去焦点
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

