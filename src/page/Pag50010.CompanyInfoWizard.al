page 50010 "CompanyInfoWizard"
{
  Caption='Company Info Wizard';
  PageType = NavigatePage;
  SourceTable = "Company Information";

  layout
  {
    area(content)
    {
      group(StandardBanner)
      {
        Caption='';
        Editable=false;
        Visible=TopBannerVisible AND (CurrentStep < 3);
        field(MediaResourcesStandard;MediaResourcesStandard."Media Reference")
        {
          ApplicationArea = All;
          Editable=false;
          ShowCaption=false;
        }
      }
      group(FinishedBanner)
      {
        Caption='';
        Editable=false;
        Visible=TopBannerVisible AND (CurrentStep = 3);
        field(MediaResourcesDone;MediaResourcesDone."Media Reference")
        {
          ApplicationArea = All;
          Editable=false;
          ShowCaption=false;
        }
      }

      group(Step1)
      {
        Visible = CurrentStep = 1;
        group(CompanyName)
        {
          Caption='Welcome to Company Information Setup';
          InstructionalText='Schritt1 - Bitte geben Sie den Firmennamen ein';
          field(Name;Name)
          {
            ApplicationArea = All;
          }
        }
      }

      group(Step2)
      {
        Visible = CurrentStep = 2;
        group(EmailAdreass)
        {
          Caption=' ';
          InstructionalText='Schritt2 - Geben Sie die E-Mail Adresse ein';

          field("E-Mail";"E-Mail")
          {
            ApplicationArea = All;
          }
        }
      }

      group(Step3)
      {
        Visible = CurrentStep = 3;
        group(Finish)
        {
          Caption=' ';
          InstructionalText='Schritt3 - Um die Konfiguration abzuschließen, bestätigen sie dies bitte mit "Fertig"';
        }
      }
    }
  }
  actions
  {
    area(processing)
    {
      action(ActionBack)
      {
        ApplicationArea = All;
        Caption='Back';
        Enabled=ActionBackAllowed;
        Image=PreviousRecord;
        InFooterBar=true;
        trigger OnAction()
        Begin
          TakeStep(-1);
        End;
      }
      action(ActionNext)
      {
        ApplicationArea = All;
        Caption='Next';
        Enabled=ActionNextAllowed;
        Image=NextRecord;
        InFooterBar=true;

        trigger OnAction()
        Begin
          TakeStep(1);
          if UserId() = 'BC\ADMINISTRATOR' then begin 
            //Message(UserId());
          end;
        End;
      }
      action(ActionFinish)
      {
        ApplicationArea = All;
        Caption='Finish';
        Enabled=ActionFinishAllowed;
        Image=Approve;
        InFooterBar=true;

        trigger OnAction()
        Begin
          CurrPage.Close();
        End;
      }

    }
  }
  var
    CurrentStep:Integer;
    ActionFinishAllowed : Boolean;
    ActionBackAllowed : Boolean;
    ActionNextAllowed : Boolean;
    MediaRepositoryStandard : Record "Media Repository";
    MediaRepositoryDone : Record "Media Repository";
    MediaResourcesStandard : Record "Media Resources";
    MediaResourcesDone : Record "Media Resources";
    TopBannerVisible : Boolean;

  trigger OnInit();
  begin
    LoadTopBanners;
  end;

  trigger OnOpenPage();
  begin
    CurrentStep := 1;
    SetControls();
  end;
  local procedure SetControls();
  begin
    ActionBackAllowed := CurrentStep > 1;
    ActionNextAllowed := CurrentStep < 3;
    ActionFinishAllowed := CurrentStep = 3;
  end;

  local procedure TakeStep(Step:Integer)
  begin
    CurrentStep += Step;  
    SetControls();
  end;
  local procedure LoadTopBanners();
  begin
    IF MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png',FORMAT(CURRENTCLIENTTYPE)) AND
      MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png',FORMAT(CURRENTCLIENTTYPE))
    THEN
      IF MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref") AND
        MediaResourcesDone.GET(MediaRepositoryDone."Media Resources Ref")
      THEN
        TopBannerVisible := MediaResourcesDone."Media Reference".HASVALUE;
  end;
}



