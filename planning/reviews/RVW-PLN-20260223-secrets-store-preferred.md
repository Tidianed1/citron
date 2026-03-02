# Review: PLN-20260223 Secrets Store Preferred

**Plan:** [PLN-20260223-secrets-store-preferred](../plans/PLN-20260223-secrets-store-preferred.md)  
**Review Date:** 2026-03-02  
**Reviewer:** janitor  
**Status:** ✅ Approved

## Summary

This plan makes the encrypted secrets store (`LemonCore.Secrets`) the canonical method for secret access across the Lemon umbrella. Environment variables remain as a fallback for backward compatibility.

## Changes Reviewed

### 1. Bug Fix: MarketIntel.Secrets.put/2

**File:** `apps/market_intel/lib/market_intel/secrets.ex`

- **Issue:** `put/2` was calling `module.persist/2` which doesn't exist in `LemonCore.Secrets`
- **Fix:** Changed to use `module.set/3` with proper provider metadata
- **Verification:** 18 tests pass in `market_intel/secrets_test.exs`

### 2. Documentation: Secrets Migration Guide

**File:** `docs/security/secrets-migration-guide.md` (new)

- Comprehensive guide for migrating from env vars to encrypted store
- Covers quick migration, manual migration, supported secret names
- Includes troubleshooting and security best practices

### 3. Documentation: README Updates

**File:** `README.md`

- Added references to `mix lemon.secrets.check` and `mix lemon.secrets.import_env`
- Added link to migration guide

### 4. Documentation: Catalog Update

**File:** `docs/catalog.exs`

- Added entry for `docs/security/secrets-migration-guide.md`

## Verification

### Test Results

```
apps/lemon_core/test: 7 tests, 0 failures
apps/market_intel/test: 372 tests, 0 failures
```

### Code Review Checklist

- [x] No breaking changes - env fallback preserved
- [x] All existing tests pass
- [x] Bug fix verified with existing tests
- [x] Documentation complete and accurate
- [x] Migration guide covers all supported secrets

## Pre-Landing Notes

The implementation revealed that most of the work was already complete:

1. **AI providers** - All already use `Secrets.fetch_value/1`
2. **Channel adapters** - X API already uses `resolve_runtime_value/1`
3. **Coding agent tools** - Already use `Secrets.fetch_value/1`
4. **Skills** - Already use `Secrets.fetch_value/1`
5. **Import/check tasks** - Already exist and functional

The only code change needed was fixing the `MarketIntel.Secrets.put/2` bug.

## Recommendation

✅ **Approve for landing**

This plan is ready to land. The secrets store is now the preferred path with:
- Full backward compatibility (env fallback)
- Complete documentation
- Migration tooling
- All tests passing
