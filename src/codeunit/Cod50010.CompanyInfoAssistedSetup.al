codeunit 50010 "CompanyInfoAssistedSetup"
{

  [EventSubscriber(ObjectType::Table, Database::"Aggregated Assisted Setup", 'OnRegisterAssistedSetup', '', false, false)]
  local procedure AddExtensionAssistedSetup_OnRegisterAssistedSetup(var TempAggregatedAssistedSetup: Record "Aggregated Assisted Setup" TEMPORARY);
  var
    CompanyInformation: Record "Company Information";
  begin
    TempAggregatedAssistedSetup.AddExtensionAssistedSetup(Page::CompanyInfoWizard,
                              'Setup Company Information',
                              True,
                              CompanyInformation.RecordId(),
                              GetCompanyInformationStatus(TempAggregatedAssistedSetup),
                              '');
  end;

  [EventSubscriber(ObjectType::Table, Database::"Aggregated Assisted Setup", 'OnUpdateAssistedSetupStatus', '', false, false)]
  local procedure AggregatedAssistedSetup_OnUpdateAssistedSetupStatus(var TempAggregatedAssistedSetup: Record "Aggregated Assisted Setup" TEMPORARY);
  begin
    TempAggregatedAssistedSetup.SetStatus(TempAggregatedAssistedSetup, PAGE::CompanyInfoWizard, GetCompanyInformationStatus(TempAggregatedAssistedSetup));
  end;


  local procedure GetCompanyInformationStatus(AggregatedAssistedSetup: Record "Aggregated Assisted Setup"): Integer;
  var
    CompanyInformation: Record "Company Information";
  begin
    WITH AggregatedAssistedSetup DO BEGIN
      IF CompanyInformation.Get() THEN
        if (CompanyInformation.Name = '') OR (CompanyInformation."E-Mail" = '') then
          Status := Status::"Not Completed"
        else
          Status := Status::Completed
      ELSE
        Status := Status::"Not Completed";
      EXIT(Status);
    END;
  end;
}