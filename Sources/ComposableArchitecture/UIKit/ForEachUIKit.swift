import Combine

extension Store {
    public func forEach<EachState, EachAction, ID> (
        _ body: @escaping (Store<EachState, EachAction>) -> Void
    ) -> Cancellable where ID: Hashable, State == IdentifiedArray<ID, EachState>, Action == (ID, EachAction) {
        self.state
            .removeDuplicates(by: { $0.ids == $1.ids})
            .sink { state in
                state.ids.forEach { id in
                    var element = self.state.value[id: id]!
                    body(
                        self.scope(
                            state: {
                                element = $0[id: id] ?? element
                                return element
                            },
                            action: { (id, $0) }
                        )
                    )
                }
            }
    }

    public func forEach<EachState, EachAction, ID> (
        onChange: @escaping () -> Void,
        _ body: @escaping (Store<EachState, EachAction>) -> Void
    ) -> Cancellable where ID: Hashable, State == IdentifiedArray<ID, EachState>, Action == (ID, EachAction) {
        self.state
            .removeDuplicates(by: { $0.ids == $1.ids})
            .sink { state in
                onChange()
                state.ids.forEach { id in
                    var element = self.state.value[id: id]!
                    body(
                        self.scope(
                            state: {
                                element = $0[id: id] ?? element
                                return element
                            },
                            action: { (id, $0) }
                        )
                    )
                }
            }
    }

}
