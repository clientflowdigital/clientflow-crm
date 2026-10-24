// FIXME: This should be exported from the ra-core package
type CanAccessParams<
  RecordType extends Record<string, any> = Record<string, any>,
> = {
  action: string;
  resource: string;
  record?: RecordType;
};

export const canAccess = <
  RecordType extends Record<string, any> = Record<string, any>,
>(
  role: string,
  params: CanAccessParams<RecordType>,
) => {
  if (role === "admin") {
    return true;
  }

  // Non admins can't access the sales resource
  if (params.resource === "sales") {
    return false;
  }

  // Non admins can't access the configuration resource
  if (params.resource === "configuration") {
    return false;
  }

  // Marketing users never see deals (they carry amounts), can't change
  // companies, and can't delete or merge contacts. The RLS policies enforce
  // the same rules in the database; this only hides what they can't use.
  if (role === "marketing") {
    if (["deals", "deal_notes"].includes(params.resource)) {
      return false;
    }
    if (
      params.resource === "companies" &&
      params.action !== "list" &&
      params.action !== "show"
    ) {
      return false;
    }
    if (params.resource === "contacts" && params.action === "delete") {
      return false;
    }
  }

  return true;
};
