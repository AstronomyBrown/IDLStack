/**
 * DBResource.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class DBResource  implements java.io.Serializable {
    private long dbid;
    private int status;
    private java.lang.String identifier;
    private java.lang.String title;
    private java.lang.String shortName;
    private java.lang.String curationPublisherName;
    private java.lang.String curationPublisherIdentifier;
    private java.lang.String curationPublisherDescription;
    private java.lang.String curationPublisherReferenceUrl;
    private java.lang.String curationCreatorName;
    private java.lang.String curationCreatorLogo;
    private java.lang.String curationContributor;
    private java.util.Calendar curationDate;
    private java.lang.String curationVersion;
    private java.lang.String curationContactName;
    private java.lang.String curationContactEmail;
    private java.lang.String curationContactAddress;
    private java.lang.String curationContactPhone;
    private org.us_vo.www.ArrayOfString subject;
    private java.lang.String description;
    private java.lang.String referenceURL;
    private java.lang.String type;
    private java.lang.String facility;
    private org.us_vo.www.ArrayOfString instrument;
    private org.us_vo.www.ArrayOfString contentLevel;
    private java.util.Calendar modificationDate;
    private java.lang.String serviceURL;
    private java.lang.String coverageSpatial;
    private org.us_vo.www.ArrayOfString coverageSpectral;
    private java.lang.String coverageTemporal;
    private double coverageRegionOfRegard;
    private java.lang.String resourceType;
    private org.us_vo.www.ArrayOfResourceRelation resourceRelations;
    private org.us_vo.www.ArrayOfResourceInterface resourceInterfaces;
    private java.lang.String xml;
    private java.lang.String harvestedfrom;
    private java.util.Calendar harvestedfromDate;
    private java.lang.String footprint;

    public DBResource() {
    }


    /**
     * Gets the dbid value for this DBResource.
     * 
     * @return dbid
     */
    public long getDbid() {
        return dbid;
    }


    /**
     * Sets the dbid value for this DBResource.
     * 
     * @param dbid
     */
    public void setDbid(long dbid) {
        this.dbid = dbid;
    }


    /**
     * Gets the status value for this DBResource.
     * 
     * @return status
     */
    public int getStatus() {
        return status;
    }


    /**
     * Sets the status value for this DBResource.
     * 
     * @param status
     */
    public void setStatus(int status) {
        this.status = status;
    }


    /**
     * Gets the identifier value for this DBResource.
     * 
     * @return identifier
     */
    public java.lang.String getIdentifier() {
        return identifier;
    }


    /**
     * Sets the identifier value for this DBResource.
     * 
     * @param identifier
     */
    public void setIdentifier(java.lang.String identifier) {
        this.identifier = identifier;
    }


    /**
     * Gets the title value for this DBResource.
     * 
     * @return title
     */
    public java.lang.String getTitle() {
        return title;
    }


    /**
     * Sets the title value for this DBResource.
     * 
     * @param title
     */
    public void setTitle(java.lang.String title) {
        this.title = title;
    }


    /**
     * Gets the shortName value for this DBResource.
     * 
     * @return shortName
     */
    public java.lang.String getShortName() {
        return shortName;
    }


    /**
     * Sets the shortName value for this DBResource.
     * 
     * @param shortName
     */
    public void setShortName(java.lang.String shortName) {
        this.shortName = shortName;
    }


    /**
     * Gets the curationPublisherName value for this DBResource.
     * 
     * @return curationPublisherName
     */
    public java.lang.String getCurationPublisherName() {
        return curationPublisherName;
    }


    /**
     * Sets the curationPublisherName value for this DBResource.
     * 
     * @param curationPublisherName
     */
    public void setCurationPublisherName(java.lang.String curationPublisherName) {
        this.curationPublisherName = curationPublisherName;
    }


    /**
     * Gets the curationPublisherIdentifier value for this DBResource.
     * 
     * @return curationPublisherIdentifier
     */
    public java.lang.String getCurationPublisherIdentifier() {
        return curationPublisherIdentifier;
    }


    /**
     * Sets the curationPublisherIdentifier value for this DBResource.
     * 
     * @param curationPublisherIdentifier
     */
    public void setCurationPublisherIdentifier(java.lang.String curationPublisherIdentifier) {
        this.curationPublisherIdentifier = curationPublisherIdentifier;
    }


    /**
     * Gets the curationPublisherDescription value for this DBResource.
     * 
     * @return curationPublisherDescription
     */
    public java.lang.String getCurationPublisherDescription() {
        return curationPublisherDescription;
    }


    /**
     * Sets the curationPublisherDescription value for this DBResource.
     * 
     * @param curationPublisherDescription
     */
    public void setCurationPublisherDescription(java.lang.String curationPublisherDescription) {
        this.curationPublisherDescription = curationPublisherDescription;
    }


    /**
     * Gets the curationPublisherReferenceUrl value for this DBResource.
     * 
     * @return curationPublisherReferenceUrl
     */
    public java.lang.String getCurationPublisherReferenceUrl() {
        return curationPublisherReferenceUrl;
    }


    /**
     * Sets the curationPublisherReferenceUrl value for this DBResource.
     * 
     * @param curationPublisherReferenceUrl
     */
    public void setCurationPublisherReferenceUrl(java.lang.String curationPublisherReferenceUrl) {
        this.curationPublisherReferenceUrl = curationPublisherReferenceUrl;
    }


    /**
     * Gets the curationCreatorName value for this DBResource.
     * 
     * @return curationCreatorName
     */
    public java.lang.String getCurationCreatorName() {
        return curationCreatorName;
    }


    /**
     * Sets the curationCreatorName value for this DBResource.
     * 
     * @param curationCreatorName
     */
    public void setCurationCreatorName(java.lang.String curationCreatorName) {
        this.curationCreatorName = curationCreatorName;
    }


    /**
     * Gets the curationCreatorLogo value for this DBResource.
     * 
     * @return curationCreatorLogo
     */
    public java.lang.String getCurationCreatorLogo() {
        return curationCreatorLogo;
    }


    /**
     * Sets the curationCreatorLogo value for this DBResource.
     * 
     * @param curationCreatorLogo
     */
    public void setCurationCreatorLogo(java.lang.String curationCreatorLogo) {
        this.curationCreatorLogo = curationCreatorLogo;
    }


    /**
     * Gets the curationContributor value for this DBResource.
     * 
     * @return curationContributor
     */
    public java.lang.String getCurationContributor() {
        return curationContributor;
    }


    /**
     * Sets the curationContributor value for this DBResource.
     * 
     * @param curationContributor
     */
    public void setCurationContributor(java.lang.String curationContributor) {
        this.curationContributor = curationContributor;
    }


    /**
     * Gets the curationDate value for this DBResource.
     * 
     * @return curationDate
     */
    public java.util.Calendar getCurationDate() {
        return curationDate;
    }


    /**
     * Sets the curationDate value for this DBResource.
     * 
     * @param curationDate
     */
    public void setCurationDate(java.util.Calendar curationDate) {
        this.curationDate = curationDate;
    }


    /**
     * Gets the curationVersion value for this DBResource.
     * 
     * @return curationVersion
     */
    public java.lang.String getCurationVersion() {
        return curationVersion;
    }


    /**
     * Sets the curationVersion value for this DBResource.
     * 
     * @param curationVersion
     */
    public void setCurationVersion(java.lang.String curationVersion) {
        this.curationVersion = curationVersion;
    }


    /**
     * Gets the curationContactName value for this DBResource.
     * 
     * @return curationContactName
     */
    public java.lang.String getCurationContactName() {
        return curationContactName;
    }


    /**
     * Sets the curationContactName value for this DBResource.
     * 
     * @param curationContactName
     */
    public void setCurationContactName(java.lang.String curationContactName) {
        this.curationContactName = curationContactName;
    }


    /**
     * Gets the curationContactEmail value for this DBResource.
     * 
     * @return curationContactEmail
     */
    public java.lang.String getCurationContactEmail() {
        return curationContactEmail;
    }


    /**
     * Sets the curationContactEmail value for this DBResource.
     * 
     * @param curationContactEmail
     */
    public void setCurationContactEmail(java.lang.String curationContactEmail) {
        this.curationContactEmail = curationContactEmail;
    }


    /**
     * Gets the curationContactAddress value for this DBResource.
     * 
     * @return curationContactAddress
     */
    public java.lang.String getCurationContactAddress() {
        return curationContactAddress;
    }


    /**
     * Sets the curationContactAddress value for this DBResource.
     * 
     * @param curationContactAddress
     */
    public void setCurationContactAddress(java.lang.String curationContactAddress) {
        this.curationContactAddress = curationContactAddress;
    }


    /**
     * Gets the curationContactPhone value for this DBResource.
     * 
     * @return curationContactPhone
     */
    public java.lang.String getCurationContactPhone() {
        return curationContactPhone;
    }


    /**
     * Sets the curationContactPhone value for this DBResource.
     * 
     * @param curationContactPhone
     */
    public void setCurationContactPhone(java.lang.String curationContactPhone) {
        this.curationContactPhone = curationContactPhone;
    }


    /**
     * Gets the subject value for this DBResource.
     * 
     * @return subject
     */
    public org.us_vo.www.ArrayOfString getSubject() {
        return subject;
    }


    /**
     * Sets the subject value for this DBResource.
     * 
     * @param subject
     */
    public void setSubject(org.us_vo.www.ArrayOfString subject) {
        this.subject = subject;
    }


    /**
     * Gets the description value for this DBResource.
     * 
     * @return description
     */
    public java.lang.String getDescription() {
        return description;
    }


    /**
     * Sets the description value for this DBResource.
     * 
     * @param description
     */
    public void setDescription(java.lang.String description) {
        this.description = description;
    }


    /**
     * Gets the referenceURL value for this DBResource.
     * 
     * @return referenceURL
     */
    public java.lang.String getReferenceURL() {
        return referenceURL;
    }


    /**
     * Sets the referenceURL value for this DBResource.
     * 
     * @param referenceURL
     */
    public void setReferenceURL(java.lang.String referenceURL) {
        this.referenceURL = referenceURL;
    }


    /**
     * Gets the type value for this DBResource.
     * 
     * @return type
     */
    public java.lang.String getType() {
        return type;
    }


    /**
     * Sets the type value for this DBResource.
     * 
     * @param type
     */
    public void setType(java.lang.String type) {
        this.type = type;
    }


    /**
     * Gets the facility value for this DBResource.
     * 
     * @return facility
     */
    public java.lang.String getFacility() {
        return facility;
    }


    /**
     * Sets the facility value for this DBResource.
     * 
     * @param facility
     */
    public void setFacility(java.lang.String facility) {
        this.facility = facility;
    }


    /**
     * Gets the instrument value for this DBResource.
     * 
     * @return instrument
     */
    public org.us_vo.www.ArrayOfString getInstrument() {
        return instrument;
    }


    /**
     * Sets the instrument value for this DBResource.
     * 
     * @param instrument
     */
    public void setInstrument(org.us_vo.www.ArrayOfString instrument) {
        this.instrument = instrument;
    }


    /**
     * Gets the contentLevel value for this DBResource.
     * 
     * @return contentLevel
     */
    public org.us_vo.www.ArrayOfString getContentLevel() {
        return contentLevel;
    }


    /**
     * Sets the contentLevel value for this DBResource.
     * 
     * @param contentLevel
     */
    public void setContentLevel(org.us_vo.www.ArrayOfString contentLevel) {
        this.contentLevel = contentLevel;
    }


    /**
     * Gets the modificationDate value for this DBResource.
     * 
     * @return modificationDate
     */
    public java.util.Calendar getModificationDate() {
        return modificationDate;
    }


    /**
     * Sets the modificationDate value for this DBResource.
     * 
     * @param modificationDate
     */
    public void setModificationDate(java.util.Calendar modificationDate) {
        this.modificationDate = modificationDate;
    }


    /**
     * Gets the serviceURL value for this DBResource.
     * 
     * @return serviceURL
     */
    public java.lang.String getServiceURL() {
        return serviceURL;
    }


    /**
     * Sets the serviceURL value for this DBResource.
     * 
     * @param serviceURL
     */
    public void setServiceURL(java.lang.String serviceURL) {
        this.serviceURL = serviceURL;
    }


    /**
     * Gets the coverageSpatial value for this DBResource.
     * 
     * @return coverageSpatial
     */
    public java.lang.String getCoverageSpatial() {
        return coverageSpatial;
    }


    /**
     * Sets the coverageSpatial value for this DBResource.
     * 
     * @param coverageSpatial
     */
    public void setCoverageSpatial(java.lang.String coverageSpatial) {
        this.coverageSpatial = coverageSpatial;
    }


    /**
     * Gets the coverageSpectral value for this DBResource.
     * 
     * @return coverageSpectral
     */
    public org.us_vo.www.ArrayOfString getCoverageSpectral() {
        return coverageSpectral;
    }


    /**
     * Sets the coverageSpectral value for this DBResource.
     * 
     * @param coverageSpectral
     */
    public void setCoverageSpectral(org.us_vo.www.ArrayOfString coverageSpectral) {
        this.coverageSpectral = coverageSpectral;
    }


    /**
     * Gets the coverageTemporal value for this DBResource.
     * 
     * @return coverageTemporal
     */
    public java.lang.String getCoverageTemporal() {
        return coverageTemporal;
    }


    /**
     * Sets the coverageTemporal value for this DBResource.
     * 
     * @param coverageTemporal
     */
    public void setCoverageTemporal(java.lang.String coverageTemporal) {
        this.coverageTemporal = coverageTemporal;
    }


    /**
     * Gets the coverageRegionOfRegard value for this DBResource.
     * 
     * @return coverageRegionOfRegard
     */
    public double getCoverageRegionOfRegard() {
        return coverageRegionOfRegard;
    }


    /**
     * Sets the coverageRegionOfRegard value for this DBResource.
     * 
     * @param coverageRegionOfRegard
     */
    public void setCoverageRegionOfRegard(double coverageRegionOfRegard) {
        this.coverageRegionOfRegard = coverageRegionOfRegard;
    }


    /**
     * Gets the resourceType value for this DBResource.
     * 
     * @return resourceType
     */
    public java.lang.String getResourceType() {
        return resourceType;
    }


    /**
     * Sets the resourceType value for this DBResource.
     * 
     * @param resourceType
     */
    public void setResourceType(java.lang.String resourceType) {
        this.resourceType = resourceType;
    }


    /**
     * Gets the resourceRelations value for this DBResource.
     * 
     * @return resourceRelations
     */
    public org.us_vo.www.ArrayOfResourceRelation getResourceRelations() {
        return resourceRelations;
    }


    /**
     * Sets the resourceRelations value for this DBResource.
     * 
     * @param resourceRelations
     */
    public void setResourceRelations(org.us_vo.www.ArrayOfResourceRelation resourceRelations) {
        this.resourceRelations = resourceRelations;
    }


    /**
     * Gets the resourceInterfaces value for this DBResource.
     * 
     * @return resourceInterfaces
     */
    public org.us_vo.www.ArrayOfResourceInterface getResourceInterfaces() {
        return resourceInterfaces;
    }


    /**
     * Sets the resourceInterfaces value for this DBResource.
     * 
     * @param resourceInterfaces
     */
    public void setResourceInterfaces(org.us_vo.www.ArrayOfResourceInterface resourceInterfaces) {
        this.resourceInterfaces = resourceInterfaces;
    }


    /**
     * Gets the xml value for this DBResource.
     * 
     * @return xml
     */
    public java.lang.String getXml() {
        return xml;
    }


    /**
     * Sets the xml value for this DBResource.
     * 
     * @param xml
     */
    public void setXml(java.lang.String xml) {
        this.xml = xml;
    }


    /**
     * Gets the harvestedfrom value for this DBResource.
     * 
     * @return harvestedfrom
     */
    public java.lang.String getHarvestedfrom() {
        return harvestedfrom;
    }


    /**
     * Sets the harvestedfrom value for this DBResource.
     * 
     * @param harvestedfrom
     */
    public void setHarvestedfrom(java.lang.String harvestedfrom) {
        this.harvestedfrom = harvestedfrom;
    }


    /**
     * Gets the harvestedfromDate value for this DBResource.
     * 
     * @return harvestedfromDate
     */
    public java.util.Calendar getHarvestedfromDate() {
        return harvestedfromDate;
    }


    /**
     * Sets the harvestedfromDate value for this DBResource.
     * 
     * @param harvestedfromDate
     */
    public void setHarvestedfromDate(java.util.Calendar harvestedfromDate) {
        this.harvestedfromDate = harvestedfromDate;
    }


    /**
     * Gets the footprint value for this DBResource.
     * 
     * @return footprint
     */
    public java.lang.String getFootprint() {
        return footprint;
    }


    /**
     * Sets the footprint value for this DBResource.
     * 
     * @param footprint
     */
    public void setFootprint(java.lang.String footprint) {
        this.footprint = footprint;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DBResource)) return false;
        DBResource other = (DBResource) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.dbid == other.getDbid() &&
            this.status == other.getStatus() &&
            ((this.identifier==null && other.getIdentifier()==null) || 
             (this.identifier!=null &&
              this.identifier.equals(other.getIdentifier()))) &&
            ((this.title==null && other.getTitle()==null) || 
             (this.title!=null &&
              this.title.equals(other.getTitle()))) &&
            ((this.shortName==null && other.getShortName()==null) || 
             (this.shortName!=null &&
              this.shortName.equals(other.getShortName()))) &&
            ((this.curationPublisherName==null && other.getCurationPublisherName()==null) || 
             (this.curationPublisherName!=null &&
              this.curationPublisherName.equals(other.getCurationPublisherName()))) &&
            ((this.curationPublisherIdentifier==null && other.getCurationPublisherIdentifier()==null) || 
             (this.curationPublisherIdentifier!=null &&
              this.curationPublisherIdentifier.equals(other.getCurationPublisherIdentifier()))) &&
            ((this.curationPublisherDescription==null && other.getCurationPublisherDescription()==null) || 
             (this.curationPublisherDescription!=null &&
              this.curationPublisherDescription.equals(other.getCurationPublisherDescription()))) &&
            ((this.curationPublisherReferenceUrl==null && other.getCurationPublisherReferenceUrl()==null) || 
             (this.curationPublisherReferenceUrl!=null &&
              this.curationPublisherReferenceUrl.equals(other.getCurationPublisherReferenceUrl()))) &&
            ((this.curationCreatorName==null && other.getCurationCreatorName()==null) || 
             (this.curationCreatorName!=null &&
              this.curationCreatorName.equals(other.getCurationCreatorName()))) &&
            ((this.curationCreatorLogo==null && other.getCurationCreatorLogo()==null) || 
             (this.curationCreatorLogo!=null &&
              this.curationCreatorLogo.equals(other.getCurationCreatorLogo()))) &&
            ((this.curationContributor==null && other.getCurationContributor()==null) || 
             (this.curationContributor!=null &&
              this.curationContributor.equals(other.getCurationContributor()))) &&
            ((this.curationDate==null && other.getCurationDate()==null) || 
             (this.curationDate!=null &&
              this.curationDate.equals(other.getCurationDate()))) &&
            ((this.curationVersion==null && other.getCurationVersion()==null) || 
             (this.curationVersion!=null &&
              this.curationVersion.equals(other.getCurationVersion()))) &&
            ((this.curationContactName==null && other.getCurationContactName()==null) || 
             (this.curationContactName!=null &&
              this.curationContactName.equals(other.getCurationContactName()))) &&
            ((this.curationContactEmail==null && other.getCurationContactEmail()==null) || 
             (this.curationContactEmail!=null &&
              this.curationContactEmail.equals(other.getCurationContactEmail()))) &&
            ((this.curationContactAddress==null && other.getCurationContactAddress()==null) || 
             (this.curationContactAddress!=null &&
              this.curationContactAddress.equals(other.getCurationContactAddress()))) &&
            ((this.curationContactPhone==null && other.getCurationContactPhone()==null) || 
             (this.curationContactPhone!=null &&
              this.curationContactPhone.equals(other.getCurationContactPhone()))) &&
            ((this.subject==null && other.getSubject()==null) || 
             (this.subject!=null &&
              this.subject.equals(other.getSubject()))) &&
            ((this.description==null && other.getDescription()==null) || 
             (this.description!=null &&
              this.description.equals(other.getDescription()))) &&
            ((this.referenceURL==null && other.getReferenceURL()==null) || 
             (this.referenceURL!=null &&
              this.referenceURL.equals(other.getReferenceURL()))) &&
            ((this.type==null && other.getType()==null) || 
             (this.type!=null &&
              this.type.equals(other.getType()))) &&
            ((this.facility==null && other.getFacility()==null) || 
             (this.facility!=null &&
              this.facility.equals(other.getFacility()))) &&
            ((this.instrument==null && other.getInstrument()==null) || 
             (this.instrument!=null &&
              this.instrument.equals(other.getInstrument()))) &&
            ((this.contentLevel==null && other.getContentLevel()==null) || 
             (this.contentLevel!=null &&
              this.contentLevel.equals(other.getContentLevel()))) &&
            ((this.modificationDate==null && other.getModificationDate()==null) || 
             (this.modificationDate!=null &&
              this.modificationDate.equals(other.getModificationDate()))) &&
            ((this.serviceURL==null && other.getServiceURL()==null) || 
             (this.serviceURL!=null &&
              this.serviceURL.equals(other.getServiceURL()))) &&
            ((this.coverageSpatial==null && other.getCoverageSpatial()==null) || 
             (this.coverageSpatial!=null &&
              this.coverageSpatial.equals(other.getCoverageSpatial()))) &&
            ((this.coverageSpectral==null && other.getCoverageSpectral()==null) || 
             (this.coverageSpectral!=null &&
              this.coverageSpectral.equals(other.getCoverageSpectral()))) &&
            ((this.coverageTemporal==null && other.getCoverageTemporal()==null) || 
             (this.coverageTemporal!=null &&
              this.coverageTemporal.equals(other.getCoverageTemporal()))) &&
            this.coverageRegionOfRegard == other.getCoverageRegionOfRegard() &&
            ((this.resourceType==null && other.getResourceType()==null) || 
             (this.resourceType!=null &&
              this.resourceType.equals(other.getResourceType()))) &&
            ((this.resourceRelations==null && other.getResourceRelations()==null) || 
             (this.resourceRelations!=null &&
              this.resourceRelations.equals(other.getResourceRelations()))) &&
            ((this.resourceInterfaces==null && other.getResourceInterfaces()==null) || 
             (this.resourceInterfaces!=null &&
              this.resourceInterfaces.equals(other.getResourceInterfaces()))) &&
            ((this.xml==null && other.getXml()==null) || 
             (this.xml!=null &&
              this.xml.equals(other.getXml()))) &&
            ((this.harvestedfrom==null && other.getHarvestedfrom()==null) || 
             (this.harvestedfrom!=null &&
              this.harvestedfrom.equals(other.getHarvestedfrom()))) &&
            ((this.harvestedfromDate==null && other.getHarvestedfromDate()==null) || 
             (this.harvestedfromDate!=null &&
              this.harvestedfromDate.equals(other.getHarvestedfromDate()))) &&
            ((this.footprint==null && other.getFootprint()==null) || 
             (this.footprint!=null &&
              this.footprint.equals(other.getFootprint())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        _hashCode += new Long(getDbid()).hashCode();
        _hashCode += getStatus();
        if (getIdentifier() != null) {
            _hashCode += getIdentifier().hashCode();
        }
        if (getTitle() != null) {
            _hashCode += getTitle().hashCode();
        }
        if (getShortName() != null) {
            _hashCode += getShortName().hashCode();
        }
        if (getCurationPublisherName() != null) {
            _hashCode += getCurationPublisherName().hashCode();
        }
        if (getCurationPublisherIdentifier() != null) {
            _hashCode += getCurationPublisherIdentifier().hashCode();
        }
        if (getCurationPublisherDescription() != null) {
            _hashCode += getCurationPublisherDescription().hashCode();
        }
        if (getCurationPublisherReferenceUrl() != null) {
            _hashCode += getCurationPublisherReferenceUrl().hashCode();
        }
        if (getCurationCreatorName() != null) {
            _hashCode += getCurationCreatorName().hashCode();
        }
        if (getCurationCreatorLogo() != null) {
            _hashCode += getCurationCreatorLogo().hashCode();
        }
        if (getCurationContributor() != null) {
            _hashCode += getCurationContributor().hashCode();
        }
        if (getCurationDate() != null) {
            _hashCode += getCurationDate().hashCode();
        }
        if (getCurationVersion() != null) {
            _hashCode += getCurationVersion().hashCode();
        }
        if (getCurationContactName() != null) {
            _hashCode += getCurationContactName().hashCode();
        }
        if (getCurationContactEmail() != null) {
            _hashCode += getCurationContactEmail().hashCode();
        }
        if (getCurationContactAddress() != null) {
            _hashCode += getCurationContactAddress().hashCode();
        }
        if (getCurationContactPhone() != null) {
            _hashCode += getCurationContactPhone().hashCode();
        }
        if (getSubject() != null) {
            _hashCode += getSubject().hashCode();
        }
        if (getDescription() != null) {
            _hashCode += getDescription().hashCode();
        }
        if (getReferenceURL() != null) {
            _hashCode += getReferenceURL().hashCode();
        }
        if (getType() != null) {
            _hashCode += getType().hashCode();
        }
        if (getFacility() != null) {
            _hashCode += getFacility().hashCode();
        }
        if (getInstrument() != null) {
            _hashCode += getInstrument().hashCode();
        }
        if (getContentLevel() != null) {
            _hashCode += getContentLevel().hashCode();
        }
        if (getModificationDate() != null) {
            _hashCode += getModificationDate().hashCode();
        }
        if (getServiceURL() != null) {
            _hashCode += getServiceURL().hashCode();
        }
        if (getCoverageSpatial() != null) {
            _hashCode += getCoverageSpatial().hashCode();
        }
        if (getCoverageSpectral() != null) {
            _hashCode += getCoverageSpectral().hashCode();
        }
        if (getCoverageTemporal() != null) {
            _hashCode += getCoverageTemporal().hashCode();
        }
        _hashCode += new Double(getCoverageRegionOfRegard()).hashCode();
        if (getResourceType() != null) {
            _hashCode += getResourceType().hashCode();
        }
        if (getResourceRelations() != null) {
            _hashCode += getResourceRelations().hashCode();
        }
        if (getResourceInterfaces() != null) {
            _hashCode += getResourceInterfaces().hashCode();
        }
        if (getXml() != null) {
            _hashCode += getXml().hashCode();
        }
        if (getHarvestedfrom() != null) {
            _hashCode += getHarvestedfrom().hashCode();
        }
        if (getHarvestedfromDate() != null) {
            _hashCode += getHarvestedfromDate().hashCode();
        }
        if (getFootprint() != null) {
            _hashCode += getFootprint().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DBResource.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "DBResource"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dbid");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "dbid"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "long"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("status");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "status"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("identifier");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "Identifier"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("title");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "Title"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("shortName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "ShortName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationPublisherName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationPublisherName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationPublisherIdentifier");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationPublisherIdentifier"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationPublisherDescription");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationPublisherDescription"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationPublisherReferenceUrl");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationPublisherReferenceUrl"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationCreatorName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationCreatorName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationCreatorLogo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationCreatorLogo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationContributor");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationContributor"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationDate");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "dateTime"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationVersion");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationVersion"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationContactName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationContactName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationContactEmail");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationContactEmail"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationContactAddress");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationContactAddress"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("curationContactPhone");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CurationContactPhone"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("subject");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "Subject"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfString"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("description");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "Description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("referenceURL");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "ReferenceURL"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("type");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "Type"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("facility");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "Facility"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("instrument");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "Instrument"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfString"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("contentLevel");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "ContentLevel"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfString"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("modificationDate");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "ModificationDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "dateTime"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("serviceURL");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "ServiceURL"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coverageSpatial");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CoverageSpatial"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coverageSpectral");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CoverageSpectral"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfString"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coverageTemporal");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CoverageTemporal"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coverageRegionOfRegard");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "CoverageRegionOfRegard"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resourceType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "ResourceType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resourceRelations");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "resourceRelations"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfResourceRelation"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resourceInterfaces");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "resourceInterfaces"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfResourceInterface"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("xml");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "xml"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("harvestedfrom");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "harvestedfrom"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("harvestedfromDate");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "harvestedfromDate"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "dateTime"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("footprint");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "footprint"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
