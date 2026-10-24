import type { Deal, DealCurrency } from "../types";

// Fixed ClientFlow deal options, from the company profile. Services,
// industries and task types stay editable in Settings instead.

export const leadSources = [
  { value: "referral", label: "Referral" },
  { value: "social-media", label: "Social media" },
  { value: "ads", label: "Ads" },
  { value: "website", label: "Website" },
  { value: "outreach", label: "Outreach" },
  { value: "networking", label: "Networking" },
];

export const dealPackages = [
  { value: "starter", label: "Starter" },
  { value: "growth", label: "Growth" },
  { value: "scale", label: "Scale" },
  { value: "enterprise", label: "Enterprise" },
];

export const revenueTypes = [
  { value: "one-time", label: "One-time" },
  { value: "recurring", label: "Recurring (monthly)" },
];

// ZWG is the ISO code for the Zimbabwe Gold currency, shown as "ZiG".
export const dealCurrencies: { value: DealCurrency; label: string }[] = [
  { value: "USD", label: "USD" },
  { value: "ZWG", label: "ZiG" },
];

export const DEFAULT_DEAL_CURRENCY: DealCurrency = "USD";

export const findOptionLabel = (
  options: { value: string; label: string }[],
  value?: string | null,
) => (value ? (options.find((o) => o.value === value)?.label ?? value) : "");

// Deal amounts are stored as whole numbers, so no decimals are shown.
export const formatMoney = (
  amount: number,
  currency?: string | null,
  { compact = false }: { compact?: boolean } = {},
) =>
  amount
    .toLocaleString("en-US", {
      style: "currency",
      currency: currency || DEFAULT_DEAL_CURRENCY,
      currencyDisplay: "narrowSymbol",
      ...(compact
        ? { notation: "compact", minimumSignificantDigits: 3 }
        : { minimumFractionDigits: 0, maximumFractionDigits: 0 }),
    })
    .replace("ZWG", "ZiG");

// USD and ZiG are never added together: one total per currency, USD first.
export const totalsByCurrency = (deals: Pick<Deal, "amount" | "currency">[]) =>
  dealCurrencies
    .map(({ value }) => ({
      currency: value,
      total: deals
        .filter((deal) => (deal.currency || DEFAULT_DEAL_CURRENCY) === value)
        .reduce((sum, deal) => sum + deal.amount, 0),
    }))
    .filter(({ total }) => total !== 0);
