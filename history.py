class History:
    def __init__(self):
        self.stack = []
        self.pred = dict()
        self.pred['brazil'] = 'japan'
        self.pred['japan'] = 'russia'
        self.pred['russia'] = 'usa'
        self.pred['usa'] = 'brazil'

    def _count_size(self) -> int:
        count = 0
        for _ in self.stack:
            count += 1
        return count

    def append(self, travel_name) -> bool:
        if self._count_size() == 4:
            self.stack.clear()
        if self._count_size() == 0:
            self.stack.append(travel_name)
            return False

        head = self.stack.pop()
        if head == self.pred[travel_name]:
            self.stack.append(head)
            self.stack.append(travel_name)
        else:
            self.stack.clear()
            return False
        if self._count_size() == 4:
            return True
        return False
