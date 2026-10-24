import { describe, expect, it } from "vitest";

import {
  findOptionLabel,
  formatMoney,
  leadSources,
  totalsByCurrency,
} from "./clientflowDealOptions";

describe("formatMoney", () => {
  it("formats USD with a dollar sign", () => {
    expect(formatMoney(1234, "USD")).toBe("$1,234");
  });

  it("shows ZWG amounts as ZiG", () => {
    // Intl separates the code from the number with a non-breaking space.
    expect(formatMoney(1234, "ZWG")).toBe("ZiG\u00a01,234");
  });

  it("falls back to USD when the currency is missing", () => {
    expect(formatMoney(100, undefined)).toBe("$100");
    expect(formatMoney(100, null)).toBe("$100");
  });

  it("supports compact notation", () => {
    expect(formatMoney(12500, "ZWG", { compact: true })).toBe("ZiG\u00a012.5K");
  });
});

describe("totalsByCurrency", () => {
  it("never adds USD and ZiG together", () => {
    expect(
      totalsByCurrency([
        { amount: 1000, currency: "USD" },
        { amount: 500, currency: "ZWG" },
        { amount: 250, currency: "USD" },
      ]),
    ).toEqual([
      { currency: "USD", total: 1250 },
      { currency: "ZWG", total: 500 },
    ]);
  });

  it("counts deals without a currency as USD", () => {
    expect(totalsByCurrency([{ amount: 300 }])).toEqual([
      { currency: "USD", total: 300 },
    ]);
  });

  it("leaves out currencies with no amount", () => {
    expect(totalsByCurrency([{ amount: 40, currency: "ZWG" }])).toEqual([
      { currency: "ZWG", total: 40 },
    ]);
    expect(totalsByCurrency([])).toEqual([]);
  });
});

describe("findOptionLabel", () => {
  it("returns the label for a known value", () => {
    expect(findOptionLabel(leadSources, "social-media")).toBe("Social media");
  });

  it("returns the raw value when unknown, and empty when missing", () => {
    expect(findOptionLabel(leadSources, "billboard")).toBe("billboard");
    expect(findOptionLabel(leadSources, null)).toBe("");
  });
});
