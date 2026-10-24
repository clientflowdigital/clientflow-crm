import { describe, expect, it } from "vitest";

import { canAccess } from "./canAccess";

describe("canAccess", () => {
  it("lets admins do everything", () => {
    expect(canAccess("admin", { resource: "sales", action: "list" })).toBe(
      true,
    );
    expect(canAccess("admin", { resource: "deals", action: "list" })).toBe(
      true,
    );
  });

  it("lets team users see deals but not users or settings", () => {
    expect(canAccess("user", { resource: "deals", action: "list" })).toBe(true);
    expect(canAccess("user", { resource: "sales", action: "list" })).toBe(
      false,
    );
    expect(
      canAccess("user", { resource: "configuration", action: "edit" }),
    ).toBe(false);
  });

  it("never shows deals or deal notes to marketing users", () => {
    for (const action of ["list", "show", "create", "edit", "delete"]) {
      expect(canAccess("marketing", { resource: "deals", action })).toBe(false);
      expect(canAccess("marketing", { resource: "deal_notes", action })).toBe(
        false,
      );
    }
  });

  it("lets marketing users view companies but not change them", () => {
    expect(
      canAccess("marketing", { resource: "companies", action: "list" }),
    ).toBe(true);
    expect(
      canAccess("marketing", { resource: "companies", action: "show" }),
    ).toBe(true);
    for (const action of ["create", "edit", "delete"]) {
      expect(canAccess("marketing", { resource: "companies", action })).toBe(
        false,
      );
    }
  });

  it("lets marketing users work with contacts, except deleting them", () => {
    expect(
      canAccess("marketing", { resource: "contacts", action: "create" }),
    ).toBe(true);
    expect(
      canAccess("marketing", { resource: "contacts", action: "edit" }),
    ).toBe(true);
    expect(
      canAccess("marketing", { resource: "contacts", action: "delete" }),
    ).toBe(false);
  });
});
