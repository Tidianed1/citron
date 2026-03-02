# Merge: PLN-20260223 Secrets Store Preferred

**Plan:** [PLN-20260223-secrets-store-preferred](../plans/PLN-20260223-secrets-store-preferred.md)  
**Review:** [RVW-PLN-20260223-secrets-store-preferred](../reviews/RVW-PLN-20260223-secrets-store-preferred.md)  
**Branch:** `feature/pln-20260302-secrets-store-preferred`  
**Status:** Ready to land

## Landing Checklist

- [x] All milestones complete
- [x] All success criteria met
- [x] Code review completed
- [x] Tests passing (372 tests)
- [x] Documentation updated
- [x] No breaking changes

## Changes to Land

### Code Changes

1. **Bug Fix:** `apps/market_intel/lib/market_intel/secrets.ex`
   - Fixed `put/2` to use correct `set/3` API instead of non-existent `persist/2`

### Documentation Changes

1. **New:** `docs/security/secrets-migration-guide.md`
   - Step-by-step migration guide from env vars to encrypted store

2. **Updated:** `README.md`
   - Added `mix lemon.secrets.check` and `mix lemon.secrets.import_env` references
   - Added migration guide link

3. **Updated:** `docs/catalog.exs`
   - Added entry for migration guide

### Planning Artifacts

1. **Updated:** `planning/plans/PLN-20260223-secrets-store-preferred.md`
   - Marked all milestones complete
   - Updated success criteria
   - Added progress log entries

2. **Updated:** `planning/INDEX.md`
   - Moved plan to Ready to Land table

3. **New:** `planning/reviews/RVW-PLN-20260223-secrets-store-preferred.md`
   - Review artifact

4. **New:** `planning/merges/MRG-PLN-20260223-secrets-store-preferred.md`
   - This file

## Landing Commands

```bash
cd ~/dev/lemon
git checkout main
git merge feature/pln-20260302-secrets-store-preferred --no-ff -m "feat(secrets): Encrypted secrets store as preferred access path

Makes LemonCore.Secrets the canonical method for secret access across
the umbrella. Environment variables remain as fallback for backward
compatibility.

Changes:
- Fixed MarketIntel.Secrets.put/2 bug (now uses correct set/3 API)
- Created comprehensive migration guide
- Updated README with migration tooling references

All tests pass (372 tests).

Closes PLN-20260223"
git push origin main
```

## Post-Landing

- [ ] Update JANITOR.md with completion summary
- [ ] Move plan to Recently Landed in INDEX.md
- [ ] Tag release if needed
