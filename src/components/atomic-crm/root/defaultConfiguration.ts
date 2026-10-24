import type { ConfigurationContextValue } from "./ConfigurationContext";
// Import the logos as module assets so Vite resolves their URL relative to the
// JS chunk (import.meta.url), not the current route. A plain "./logos/..." path
// breaks on nested routes like /oauth/consent and under a deployment sub-path.
import darkModeLogo from "@/assets/brand/clientflow-mark-dark.svg";
import lightModeLogo from "@/assets/brand/clientflow-mark-light.svg";

export const defaultDarkModeLogo = darkModeLogo;
export const defaultLightModeLogo = lightModeLogo;

export const defaultCurrency = "USD";

export const defaultTitle = "ClientFlow CRM";

// Industries ClientFlow serves. Neo can add more in Settings.
export const defaultCompanySectors = [
  { value: "construction", label: "Construction" },
  { value: "professional-services", label: "Professional Services" },
  { value: "other", label: "Other" },
];

// ClientFlow's Sales board. A deal is won once the deposit is received, the
// company's rule for starting work. "won" and "lost" keep Atomic's values,
// which the dashboard and pipeline settings rely on.
export const defaultDealStages = [
  { value: "new-enquiry", label: "New enquiry" },
  { value: "diagnosing", label: "Diagnosing" },
  { value: "proposal-sent", label: "Proposal sent" },
  { value: "won", label: "Deposit received" },
  { value: "lost", label: "Lost" },
];

export const defaultDealPipelineStatuses = ["won"];

// ClientFlow's services, from the company profile. Shown as "Service".
export const defaultDealCategories = [
  { value: "website", label: "Website" },
  { value: "brand-strategy", label: "Brand Strategy" },
  { value: "digital-growth-audit", label: "Digital Growth Audit" },
  { value: "paid-ads", label: "Paid Ads" },
  { value: "care-hosting", label: "Website Care & Hosting" },
  { value: "whatsapp-lead-capture", label: "WhatsApp Lead Capture" },
  { value: "ai-automation", label: "AI Automation" },
  { value: "custom-software", label: "Custom Software" },
  { value: "content-video", label: "Content & Video" },
  { value: "youtube", label: "YouTube" },
  { value: "seo-google-business", label: "SEO & Google Business" },
];

export const defaultNoteStatuses = [
  { value: "cold", label: "Cold", color: "#7dbde8" },
  { value: "warm", label: "Warm", color: "#e8cb7d" },
  { value: "hot", label: "Hot", color: "#e88b7d" },
  { value: "in-contract", label: "In Contract", color: "#a4e87d" },
];

export const defaultTaskTypes = [
  { value: "none", label: "None" },
  { value: "call", label: "Call" },
  { value: "whatsapp", label: "WhatsApp" },
  { value: "email", label: "Email" },
  { value: "meeting", label: "Meeting" },
  { value: "discovery-call", label: "Discovery call" },
  { value: "send-proposal", label: "Send proposal" },
  { value: "collect-content", label: "Collect content" },
  { value: "payment-follow-up", label: "Payment follow-up" },
  { value: "qa-check", label: "QA check" },
];

export const defaultConfiguration: ConfigurationContextValue = {
  companySectors: defaultCompanySectors,
  currency: defaultCurrency,
  dealCategories: defaultDealCategories,
  dealPipelineStatuses: defaultDealPipelineStatuses,
  dealStages: defaultDealStages,
  noteStatuses: defaultNoteStatuses,
  taskTypes: defaultTaskTypes,
  title: defaultTitle,
  darkModeLogo: defaultDarkModeLogo,
  lightModeLogo: defaultLightModeLogo,
};
