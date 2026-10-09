import unittest, os, sys
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from train import train

CFG = os.path.join(os.path.dirname(__file__), "..", "configs", "production.yaml")


class TrainTests(unittest.TestCase):
    def test_returns_expected_keys(self):
        self.assertEqual(set(train(CFG)), {"name", "accuracy"})

    def test_accuracy_in_range(self):
        self.assertTrue(0.0 <= train(CFG)["accuracy"] <= 1.0)

    def test_deterministic_with_fixed_seed(self):
        self.assertEqual(train(CFG), train(CFG))


if __name__ == "__main__":
    unittest.main()
